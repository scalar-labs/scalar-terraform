resource "null_resource" "wait_for" {
  triggers = {
    network_id = local.network_id
  }
}

module "ca_cluster" {
  source = "github.com/scalar-labs/terraform-azurerm-compute?ref=b48be04"

  nb_instances                  = local.ca.resource_count
  admin_username                = local.user_name
  resource_group_name           = local.network_name
  location                      = local.region
  availability_zones            = local.locations
  vm_hostname                   = "ca"
  nb_public_ip                  = "0"
  vm_os_simple                  = local.image_id
  vnet_subnet_id                = local.subnet_id
  vm_size                       = local.ca.resource_type
  storage_os_disk_size          = local.ca.resource_root_volume_size
  delete_os_disk_on_termination = true
  ssh_key                       = local.public_key_path
  enable_accelerated_networking = local.ca.enable_accelerated_networking
}

module "ca_provision" {
  source = "../../universal/ca"

  vm_ids           = module.ca_cluster.vm_ids
  triggers         = local.triggers
  bastion_host_ip  = local.bastion_ip
  host_list        = module.ca_cluster.network_interface_private_ip
  user_name        = local.user_name
  private_key_path = local.private_key_path
  provision_count  = local.ca.resource_count
  enable_tdagent   = local.ca.enable_tdagent
  internal_domain  = local.internal_domain
}

resource "azurerm_private_dns_a_record" "ca_dns" {
  count = local.ca.resource_count

  name                = "ca-${count.index + 1}"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  records = [module.ca_cluster.network_interface_private_ip[count.index]]
}
