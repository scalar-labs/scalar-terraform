module "monitor" {
  # source = "git@github.com:scalar-labs/scalar-terraform.git//modules/aws/monitor?ref=v1.0.0"
  source = "../../../modules/aws/monitor"

  # Required Variables (Use remote state)
  network   = local.network
  cassandra = local.cassandra
  scalardl  = local.scalardl

  # Optional Variables
  base    = var.base
  monitor = var.monitor
  targets = var.targets

  slack_webhook_url = var.slack_webhook_url

  custom_tags = local.custom_tags
}
