module "bastion_cluster" {
  source = "github.com/scalar-labs/terraform-azurerm-compute?ref=upgrade-terraform-to-0.14"

  nb_instances                  = var.resource_count
  admin_username                = var.user_name
  resource_group_name           = var.network_name
  location                      = var.region
  availability_zones            = var.locations
  vm_hostname                   = "bastion"
  vm_os_simple                  = var.image_id
  vnet_subnet_id                = var.subnet_id
  nb_public_ip                  = var.resource_count
  public_ip_dns                 = formatlist("bastion-%s-${var.network_name}", range(1, var.resource_count + 1))
  vm_size                       = var.resource_type
  storage_os_disk_size          = var.resource_root_volume_size
  delete_os_disk_on_termination = true
  ssh_key                       = var.public_key_path
  enable_accelerated_networking = var.enable_accelerated_networking
}

module "bastion_provision" {
  source = "../../../universal/bastion"

  triggers                    = module.bastion_cluster.vm_ids
  bastion_host_ips            = module.bastion_cluster.public_ip_dns_name
  user_name                   = var.user_name
  private_key_path            = var.private_key_path
  additional_public_keys_path = var.additional_public_keys_path
  provision_count             = var.resource_count
  enable_tdagent              = var.enable_tdagent
  internal_domain             = var.network_dns
}

resource "azurerm_private_dns_a_record" "bastion_dns_a" {
  count = var.resource_count

  name                = "bastion-${count.index + 1}"
  zone_name           = var.network_dns
  resource_group_name = var.network_name
  ttl                 = 300

  records = [module.bastion_cluster.network_interface_private_ip[count.index]]
}

resource "azurerm_private_dns_srv_record" "bastion_dns_srv" {
  count = var.resource_count > 0 ? 1 : 0

  name                = "_node-exporter._tcp.bastion"
  zone_name           = var.network_dns
  resource_group_name = var.network_name
  ttl                 = 300

  dynamic "record" {
    for_each = azurerm_private_dns_a_record.bastion_dns_a.*.name

    content {
      priority = 0
      weight   = 0
      port     = 9100
      target   = "${record.value}.${var.network_dns}"
    }
  }
}

resource "azurerm_private_dns_srv_record" "bastion_fluentd_prometheus_dns_srv" {
  count = var.resource_count > 0 && var.enable_tdagent ? 1 : 0

  name                = "_fluentd._tcp.bastion"
  zone_name           = var.network_dns
  resource_group_name = var.network_name
  ttl                 = 300

  dynamic "record" {
    for_each = azurerm_private_dns_a_record.bastion_dns_a.*.name

    content {
      priority = 0
      weight   = 0
      port     = 24231
      target   = "${record.value}.${var.network_dns}"
    }
  }
}
