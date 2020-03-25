module "network" {
  source = "../../../../modules/aws/network"

  # Required Variables
  name             = var.name
  location         = var.location
  public_key_path  = var.public_key_path
  private_key_path = var.private_key_path
  internal_domain  = var.internal_domain

  # Optional Variables
  network = var.network
}
