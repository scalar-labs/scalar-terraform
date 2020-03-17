resource "null_resource" "wait_for" {
  triggers = {
    network_id = local.network_id
  }
}

module "ca_cluster" {
  source = "github.com/scalar-labs/terraform-azurerm-compute?ref=3b7e371"

  nb_instances                  = local.ca.resource_count
  admin_username                = local.user_name
  resource_group_name           = local.network_name
  location                      = local.location
  vm_hostname                   = "ca"
  nb_public_ip                  = "0"
  vm_os_simple                  = local.image_id
  vnet_subnet_id                = local.subnet_id
  vm_size                       = local.ca.resource_type
  storage_os_disk_size          = local.ca.resource_root_volume_size
  delete_os_disk_on_termination = true
  ssh_key                       = local.public_key_path
}

module "ca_provision" {
  source           = "../../universal/ca"
  triggers         = local.triggers
  bastion_host_ip  = local.bastion_ip
  host_list        = module.ca_cluster.network_interface_private_ip
  user_name        = local.user_name
  private_key_path = local.private_key_path
  provision_count  = local.ca.resource_count
  enable_tdagent   = local.ca.enable_tdagent
}

resource "azurerm_private_dns_a_record" "ca-dns" {
  count               = local.ca.resource_count > 0 ? 1 : 0
  name                = "ca"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  records = module.ca_cluster.network_interface_private_ip
}
