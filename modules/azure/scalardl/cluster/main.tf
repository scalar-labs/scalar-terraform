module "cluster" {
  source = "github.com/scalar-labs/terraform-azurerm-compute?ref=2d31780"

  nb_instances                  = var.resource_count
  admin_username                = var.user_name
  resource_group_name           = var.network_name
  location                      = var.region
  availability_zones            = var.locations
  vm_hostname                   = "scalardl-${var.resource_cluster_name}"
  nb_public_ip                  = "0"
  vm_os_simple                  = var.image_id
  vnet_subnet_id                = var.subnet_id
  vm_size                       = var.resource_type
  ssh_key                       = var.public_key_path
  storage_account_type          = "StandardSSD_LRS"
  storage_os_disk_size          = var.resource_root_volume_size
  availability_set_id           = var.availability_set_id
  delete_os_disk_on_termination = true
  enable_accelerated_networking = var.enable_accelerated_networking
}

module "scalardl_provision" {
  source = "../../../universal/scalardl"

  vm_ids           = module.cluster.vm_ids
  triggers         = var.triggers
  bastion_host_ip  = var.bastion_ip
  host_list        = module.cluster.network_interface_private_ip
  user_name        = var.user_name
  private_key_path = var.private_key_path
  provision_count  = var.resource_count
  enable_tdagent   = var.enable_tdagent

  scalardl_image_name          = var.scalardl_image_name
  scalardl_image_tag           = var.scalardl_image_tag
  scalardl_port                = var.scalardl_port
  scalardl_privileged_port     = var.scalardl_privileged_port
  internal_domain              = var.internal_domain
  database                     = var.database
  database_contact_points      = var.database_contact_points
  database_contact_port        = var.database_contact_port
  database_username            = var.database_username
  database_password            = var.database_password
  cassandra_replication_factor = var.cassandra_replication_factor
}
