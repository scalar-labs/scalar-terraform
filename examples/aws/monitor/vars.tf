# General Settings
variable "region" {
  default = "ap-northeast-1"
}

variable "base" {
  default = "default"
}

variable "monitor" {
  type    = map
  default = {}
}

variable "target_monitoring" {
  type = list(string)
  default = [
    "cassandra",
    "scalardl",
  ]
}

# For Alerting Add Slack Webhook
variable "slack_webhook_url" {
  default = ""
}
