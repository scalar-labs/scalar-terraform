module "cluster" {
  source = "github.com/scalar-labs/terraform-azurerm-compute?ref=upgrade-base-to-2.0.0"

  nb_instances                  = var.resource_count
  admin_username                = var.user_name
  resource_group_name           = var.network_name
  location                      = var.location
  vm_hostname                   = "scalar-${var.resource_cluster_name}"
  nb_public_ip                  = "0"
  vm_os_simple                  = var.image_id
  vnet_subnet_id                = var.subnet_id
  vm_size                       = var.resource_type
  ssh_key                       = var.public_key_path
  storage_os_disk_size          = var.resource_root_volume_size
  availability_set_id           = var.availability_set_id
  delete_os_disk_on_termination = true
}

module "scalardl_provision" {
  source = "../../../universal/scalardl"

  triggers          = var.triggers
  bastion_host_ip   = var.bastion_ip
  host_list         = module.cluster.network_interface_private_ip
  user_name         = var.user_name
  private_key_path  = var.private_key_path
  provision_count   = var.resource_count
  enable_tdagent    = var.enable_tdagent
  internal_root_dns = var.internal_root_dns

  scalardl_image_name = var.scalardl_image_name
  scalardl_image_tag  = var.scalardl_image_tag
  replication_factor  = var.replication_factor
}
