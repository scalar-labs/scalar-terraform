module "scalardl" {
  #source = "git@github.com:scalar-labs/scalar-terraform.git//modules/azure/scalardl?ref=master"
  source = "../../../../modules/azure/scalardl"

  # Required Variables (Use remote state)
  network   = local.network
  cassandra = local.cassandra

  # Optional Variables
  base     = var.base
  scalardl = var.scalardl
  envoy    = var.envoy
}
