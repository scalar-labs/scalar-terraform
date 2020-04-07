module "network" {
  source = "../../../../modules/azure/network"

  # Required Variables
  name                        = var.name
  location                    = var.location
  public_key_path             = var.public_key_path
  private_key_path            = var.private_key_path
  additional_public_keys_path = var.additional_public_keys_path
  internal_domain             = var.internal_domain

  # Optional Variables
  network = var.network
}
