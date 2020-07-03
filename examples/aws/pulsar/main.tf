module "pulsar" {
  # source = "git@github.com:scalar-labs/scalar-terraform.git//modules/aws/pulsar?ref=v1.0.0"
  source = "../../../modules/aws/pulsar"

  # Required Variables (Use network remote state)
  network = local.network

  # Optional Variables
  base      = var.base
  bookie    = var.bookie
  broker    = var.broker
  zookeeper = var.zookeeper

  custom_tags = local.custom_tags
}
