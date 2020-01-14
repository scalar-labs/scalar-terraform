region = "us-east-1"

base = "default" # bai, chiku, sho

monitor = {
  resource_type             = "t3.medium"
  resource_root_volume_size = 16
  # resource_count            = 1
  # enable_log_volume         = true
  # log_volume_size           = 500
  # log_volume_type           = "sc1"
  # enable_tdagent            = true
}

slack_webhook_url = "https://hooks.slack.com/services/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"
