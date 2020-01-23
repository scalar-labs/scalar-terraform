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

# For Alerting Add Slack Webhook
variable "slack_webhook_url" {
  default = ""
}
