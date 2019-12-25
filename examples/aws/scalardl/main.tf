module "scalardl" {
  source = "git@github.com:scalar-labs/scalardl-orchestration.git//modules/aws/scalardl?ref=feature/separate-cassandra-module-for-s3"

  # remote state vars
  network = local.network

  base = var.base

  scalardl = var.scalardl

  envoy = var.envoy
}
