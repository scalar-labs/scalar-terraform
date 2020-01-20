resource "null_resource" "wait_for" {
  triggers = {
    network_id = local.network_id
  }
}

module "cassandra_cluster" {
  source = "github.com/scalar-labs/terraform-azurerm-compute?ref=upgrade-base-to-2.0.0"

  nb_instances                  = local.cassandra.resource_count
  admin_username                = local.user_name
  resource_group_name           = local.network_name
  location                      = local.location
  vm_hostname                   = "cassandra"
  nb_public_ip                  = "0"
  vm_os_simple                  = local.image_id
  vnet_subnet_id                = local.subnet_id
  vm_size                       = local.cassandra.resource_type
  ssh_key                       = local.public_key_path
  delete_os_disk_on_termination = true
}

resource "azurerm_managed_disk" "cassandra_data_volume" {
  count      = local.cassandra.enable_data_volume && ! local.cassandra.data_use_local_volume ? local.cassandra.resource_count : 0
  depends_on = [null_resource.wait_for]

  name                 = "data-disk-cassandra${count.index}"
  location             = local.location
  resource_group_name  = local.network_name
  storage_account_type = local.cassandra.data_remote_volume_type
  create_option        = "Empty"
  disk_size_gb         = local.cassandra.data_remote_volume_size
}

resource "azurerm_virtual_machine_data_disk_attachment" "cassandra_data_volume_attachment" {
  count = local.cassandra.enable_data_volume && ! local.cassandra.data_use_local_volume ? local.cassandra.resource_count : 0

  managed_disk_id    = azurerm_managed_disk.cassandra_data_volume[count.index].id
  virtual_machine_id = module.cassandra_cluster.vm_ids[count.index]
  lun                = "5"
  caching            = "None"
}

resource "null_resource" "volume_data_remote" {
  count = local.cassandra.enable_data_volume && ! local.cassandra.data_use_local_volume ? local.cassandra.resource_count : 0

  triggers = {
    triggers = azurerm_virtual_machine_data_disk_attachment.cassandra_data_volume_attachment[count.index].id
  }

  connection {
    bastion_host = local.bastion_ip
    host         = module.cassandra_cluster.network_interface_private_ip[count.index]
    user         = local.user_name
    agent        = local.cassandra.use_agent
    private_key  = file(local.private_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sh -c 'echo export DATA_STORE=5 >> /etc/profile.d/volumes.sh'",
    ]
  }
}

resource "null_resource" "volume_data_local" {
  count = local.cassandra.enable_data_volume && local.cassandra.data_use_local_volume ? local.cassandra.resource_count : 0

  triggers = {
    triggers = module.cassandra_cluster.vm_ids[count.index]
  }

  connection {
    bastion_host = local.bastion_ip
    host         = module.cassandra_cluster.network_interface_private_ip[count.index]
    user         = local.user_name
    agent        = local.cassandra.use_agent
    private_key  = file(local.private_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sh -c 'echo export DATA_STORE=local >> /etc/profile.d/volumes.sh'",
    ]
  }
}

resource "azurerm_managed_disk" "cassandra_commitlog_volume" {
  count      = local.cassandra.enable_commitlog_volume && ! local.cassandra.commitlog_use_local_volume ? local.cassandra.resource_count : 0
  depends_on = [null_resource.wait_for]

  name                 = "commitlog-cassandra${count.index}"
  location             = local.location
  resource_group_name  = local.network_name
  storage_account_type = local.cassandra.commitlog_remote_volume_type
  create_option        = "Empty"
  disk_size_gb         = local.cassandra.commitlog_remote_volume_size
}

resource "azurerm_virtual_machine_data_disk_attachment" "cassandra_commitlog_volume_attachment" {
  count = local.cassandra.enable_commitlog_volume && ! local.cassandra.commitlog_use_local_volume ? local.cassandra.resource_count : 0

  managed_disk_id    = azurerm_managed_disk.cassandra_commitlog_volume[count.index].id
  virtual_machine_id = module.cassandra_cluster.vm_ids[count.index]
  lun                = "6"
  caching            = "None"
}

resource "null_resource" "volume_commitlog" {
  count = local.cassandra.enable_commitlog_volume && ! local.cassandra.commitlog_use_local_volume ? local.cassandra.resource_count : 0

  triggers = {
    triggers = azurerm_virtual_machine_data_disk_attachment.cassandra_commitlog_volume_attachment[count.index].id
  }

  connection {
    bastion_host = local.bastion_ip
    host         = module.cassandra_cluster.network_interface_private_ip[count.index]
    user         = local.user_name
    agent        = local.cassandra.use_agent
    private_key  = file(local.private_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sh -c 'echo export COMMIT_STORE=6 >> /etc/profile.d/volumes.sh'",
    ]
  }
}

resource "null_resource" "volume_commitlog_local" {
  count = local.cassandra.enable_commitlog_volume && local.cassandra.commitlog_use_local_volume ? local.cassandra.resource_count : 0

  triggers = {
    triggers = module.cassandra_cluster.vm_ids[count.index]
  }

  connection {
    bastion_host = local.bastion_ip
    host         = module.cassandra_cluster.network_interface_private_ip[count.index]
    user         = local.user_name
    agent        = local.cassandra.use_agent
    private_key  = file(local.private_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sh -c 'echo export COMMIT_STORE=local >> /etc/profile.d/volumes.sh'",
    ]
  }
}

module "cassandra_provision" {
  source                = "../../universal/cassandra"
  triggers              = local.triggers
  vm_ids                = module.cassandra_cluster.vm_ids
  bastion_host_ip       = local.bastion_ip
  host_list             = module.cassandra_cluster.network_interface_private_ip
  host_seed_list        = local.cassandra.resource_count > 0 ? slice(module.cassandra_cluster.network_interface_private_ip, 0, min(local.cassandra.resource_count, 3)) : []
  user_name             = local.user_name
  private_key_path      = local.private_key_path
  provision_count       = local.cassandra.resource_count
  enable_tdagent        = local.cassandra.enable_tdagent
  memtable_threshold    = local.cassandra.memtable_threshold
  cassy_public_key      = module.cassy_provision.public_key
  start_on_initial_boot = local.cassandra.start_on_initial_boot
}

resource "azurerm_dns_a_record" "cassandra-dns" {
  count = local.cassandra.resource_count

  name                = "cassandra-${count.index + 1}"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  records = [module.cassandra_cluster.network_interface_private_ip[count.index]]
}

resource "azurerm_dns_a_record" "cassandra-dns-lb" {
  count = local.cassandra.resource_count > 0 ? 1 : 0

  name                = "cassandra-lb"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  records = module.cassandra_cluster.network_interface_private_ip
}

resource "azurerm_dns_srv_record" "node-exporter-dns-srv" {
  count = local.cassandra.resource_count > 0 ? 1 : 0

  name                = "_node-exporter._tcp.cassandra"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  dynamic record {
    for_each = azurerm_dns_a_record.cassandra-dns.*.name

    content {
      priority = 0
      weight   = 0
      port     = 9100
      target   = "${record.value}.${local.internal_root_dns}"
    }
  }
}

resource "azurerm_dns_srv_record" "cassanda-exporter-dns-srv" {
  count = local.cassandra.resource_count > 0 ? 1 : 0

  name                = "_cassandra-exporter._tcp.cassandra"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  dynamic record {
    for_each = azurerm_dns_a_record.cassandra-dns.*.name

    content {
      priority = 0
      weight   = 0
      port     = 7070
      target   = "${record.value}.${local.internal_root_dns}"
    }
  }
}
