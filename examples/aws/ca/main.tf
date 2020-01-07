module "ca" {
  source = "git@github.com:scalar-labs/scalardl-terraform.git//modules/aws/ca?ref=master"
  #source = "../../../modules/aws/ca"

  # Required Variables (Use remote state)
  network = local.network

  # Optional Variables
  ca = var.ca
}
