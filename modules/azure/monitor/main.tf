resource "null_resource" "wait_for" {
  triggers = {
    network_id = local.network_id
  }
}

module "monitor_cluster" {
  source = "github.com/scalar-labs/terraform-azurerm-compute?ref=1a3c2a1"

  nb_instances                  = local.monitor.resource_count
  admin_username                = local.user_name
  resource_group_name           = local.network_name
  location                      = local.location
  vm_hostname                   = "monitor"
  nb_public_ip                  = local.monitor.set_public_access ? 1 : 0
  public_ip_dns                 = ["monitor-${local.network_name}"]
  vm_os_simple                  = local.image_id
  vnet_subnet_id                = local.subnet_id
  vm_size                       = local.monitor.resource_type
  ssh_key                       = local.public_key_path
  storage_os_disk_size          = local.monitor.resource_root_volume_size
  delete_os_disk_on_termination = true
  remote_port                   = local.monitor.remote_port
}

resource "azurerm_managed_disk" "monitor_log_volume" {
  count = local.monitor.enable_log_volume ? local.monitor.resource_count : 0

  name                 = "log-${count.index}"
  location             = local.location
  resource_group_name  = local.network_name
  storage_account_type = local.monitor.log_volume_type
  create_option        = "Empty"
  disk_size_gb         = local.monitor.log_volume_size
  depends_on           = [module.monitor_cluster]
}

resource "azurerm_virtual_machine_data_disk_attachment" "monitor_log_volume_attachment" {
  count = local.monitor.enable_log_volume ? local.monitor.resource_count : 0

  managed_disk_id    = azurerm_managed_disk.monitor_log_volume[count.index].id
  virtual_machine_id = module.monitor_cluster.vm_ids[count.index]
  lun                = "5"
  caching            = "ReadOnly"
}

resource "null_resource" "volume_data" {
  count = local.monitor.enable_log_volume ? local.monitor.resource_count : 0

  triggers = {
    volume_attachment_ids = join(
      ",",
      azurerm_virtual_machine_data_disk_attachment.monitor_log_volume_attachment.*.id,
    )
  }

  connection {
    bastion_host = local.bastion_ip
    host         = module.monitor_cluster.network_interface_private_ip[count.index]
    user         = local.user_name
    agent        = true
    private_key  = file(local.private_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sh -c 'echo export LOG_STORE=5 > /etc/profile.d/volumes.sh'",
    ]
  }
}

module "monitor_provision" {
  source = "../../universal/monitor"

  triggers         = local.triggers
  bastion_host_ip  = local.bastion_ip
  host_list        = module.monitor_cluster.network_interface_private_ip
  user_name        = local.user_name
  private_key_path = local.private_key_path
  provision_count  = local.monitor.resource_count

  slack_webhook_url             = var.slack_webhook_url
  network_id                    = local.network_id
  scalardl_blue_resource_count  = local.scalardl_blue_resource_count
  scalardl_green_resource_count = local.scalardl_green_resource_count
  cassandra_resource_count      = local.cassandra_resource_count
  replication_factor            = local.scalardl_replication_factor
  network_name                  = local.network_name
  enable_tdagent                = local.monitor.enable_tdagent
  internal_domain               = local.internal_domain
}

resource "azurerm_private_dns_a_record" "monitor-dns" {
  count = local.monitor.resource_count > 0 ? 1 : 0

  name                = "monitor"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  records = module.monitor_cluster.network_interface_private_ip
}

resource "azurerm_private_dns_a_record" "prometheus-dns" {
  count = local.monitor.resource_count > 0 ? 1 : 0

  name                = "prometheus"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  records = module.monitor_cluster.network_interface_private_ip
}

resource "azurerm_private_dns_srv_record" "monitor-exporter-dns-srv" {
  count = local.monitor.resource_count > 0 ? 1 : 0

  name                = "_node-exporter._tcp.monitor"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  dynamic record {
    for_each = azurerm_private_dns_a_record.monitor-dns.*.name

    content {
      priority = 0
      weight   = 0
      port     = 9100
      target   = "${record.value}.${local.internal_domain}"
    }
  }
}

resource "azurerm_private_dns_srv_record" "monitor-cadvisor-dns-srv" {
  count = local.monitor.resource_count > 0 ? 1 : 0

  name                = "_cadvisor._tcp.monitor"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  dynamic record {
    for_each = azurerm_private_dns_a_record.monitor-dns.*.name

    content {
      priority = 0
      weight   = 0
      port     = 18080
      target   = "${record.value}.${local.internal_domain}"
    }
  }
}
