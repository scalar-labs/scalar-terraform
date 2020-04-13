module "scalardl" {
  # source = "git@github.com:scalar-labs/scalar-terraform.git//modules/aws/scalardl?ref=v1.0.0"
  source = "../../../modules/aws/scalardl"

  # Required Variables (Use remote state)
  network   = local.network
  cassandra = local.cassandra

  # Optional Variables
  base     = var.base
  scalardl = var.scalardl
  envoy    = var.envoy

  custom_tags = local.custom_tags
}
