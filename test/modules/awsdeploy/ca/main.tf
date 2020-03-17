module "ca" {
  source = "../../../../modules/aws/ca"

  # Required Variables (Use remote state)
  network = local.network

  # Optional Variables
  ca = var.ca
}
