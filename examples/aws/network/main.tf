module "scalar-network" {
  source = "git@github.com:scalar-labs/scalar-terraform.git//modules/aws/network?ref=master"

  # Required Variables
  name             = var.name
  location         = var.location
  public_key_path  = var.public_key_path
  private_key_path = var.private_key_path

  # Custom Variables
  network = var.network
}
