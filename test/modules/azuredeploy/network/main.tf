module "scalar-network" {
  #source = "git@github.com:scalar-labs/scalar-terraform.git//modules/azure/network?ref=add-network-module-for-azure"
  source = "../../../../modules/azure/network"

  # Required Variables
  name              = var.name
  location          = var.location
  public_key_path   = var.public_key_path
  private_key_path  = var.private_key_path
  internal_root_dns = var.internal_root_dns

  # Optional Variables
  network = var.network
}
