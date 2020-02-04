module "ca" {
  #source = "git@github.com:scalar-labs/scalar-terraform.git//modules/azure/ca?ref=master"
  source = "../../../modules/azure/ca"

  # Required Variables (Use remote state)
  network = local.network

  # Optional Variables
  ca = var.ca
}
