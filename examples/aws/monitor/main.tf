module "monitor" {
  source = "git@github.com:scalar-labs/scalardl-orchestration.git//modules/aws/monitor?ref=feature/separate-cassandra-module-for-s3"

  # Required Variables (Use remote state)
  network   = local.network
  cassandra = local.cassandra
  scalardl  = local.scalardl

  # Optional Variables
  base    = var.base
  monitor = var.monitor

  slack_webhook_url = var.slack_webhook_url
}
