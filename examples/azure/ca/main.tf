module "ca" {
  source = "git@github.com:scalar-labs/scalar-terraform.git//modules/azure/ca?ref=v1.0.0"
  # source = "../../../modules/azure/ca"

  # Required Variables (Use remote state)
  network = local.network

  # Optional Variables
  ca = var.ca
}
