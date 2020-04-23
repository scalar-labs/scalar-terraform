module "bastion_cluster" {
  # TODO: Fix ref=xxxxxx
  source = "github.com/scalar-labs/terraform-azurerm-compute?ref=ca8c721"

  nb_instances                  = var.resource_count
  admin_username                = var.user_name
  resource_group_name           = var.network_name
  location                      = var.location
  vm_hostname                   = "bastion"
  vm_os_simple                  = var.image_id
  vnet_subnet_id                = var.subnet_id
  nb_public_ip                  = "1"
  public_ip_dns                 = ["bastion-${var.network_name}"]
  vm_size                       = var.resource_type
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
  provision_count             = "1"
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

  dynamic record {
    for_each = azurerm_private_dns_a_record.bastion_dns_a.*.name

    content {
      priority = 0
      weight   = 0
      port     = 9100
      target   = "${record.value}.${var.network_dns}"
    }
  }
}
