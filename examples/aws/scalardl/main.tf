module "scalardl" {
  source = "git@github.com:scalar-labs/scalardl-terraform.git//modules/aws/scalardl?ref=master"
  #source = "../../../modules/aws/scalardl"

  # Required Variables (Use network remote state)
  network = local.network

  # Optional Variables
  base     = var.base
  scalardl = var.scalardl
  envoy    = var.envoy
}
