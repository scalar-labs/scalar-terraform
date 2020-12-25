module "scalardl" {
  # source = "git@github.com:scalar-labs/scalar-terraform.git//modules/azure/scalardl?ref=v1.0.0"
  source = "../../../modules/azure/scalardl"

  # Required Variables (Use remote state)
  network   = local.network
  cassandra = local.cassandra

  # Optional Variables
  base     = var.base
  envoy    = var.envoy
  scalardl = local.scalardl
}
