module "ca" {
  source = "../../../../modules/azure/ca"

  # Required Variables (Use remote state)
  network = local.network

  # Optional Variables
  ca = var.ca
}
