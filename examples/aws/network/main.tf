module "network" {
  # source = "git@github.com:scalar-labs/scalar-terraform.git//modules/aws/network?ref=v1.0.0"
  source = "../../../modules/aws/network"

  # Required Variables
  name                        = var.name
  location                    = var.location
  public_key_path             = var.public_key_path
  private_key_path            = var.private_key_path
  internal_domain             = var.internal_domain
  additional_public_keys_path = var.additional_public_keys_path

  # Optional Variables
  network = var.network
}
