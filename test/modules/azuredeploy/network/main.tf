module "network" {
  source = "../../../../modules/azure/network"

  # Required Variables
  name                   = var.name
  location               = var.location
  public_key_path        = var.public_key_path
  private_key_path       = var.private_key_path
  public_key_folder_path = var.public_key_folder_path
  internal_domain        = var.internal_domain

  # Optional Variables
  network = var.network
}
