variable "base" {
  default     = "default"
  description = "The base of monitor resources"
}

variable "network" {
  type        = map
  description = "The network settings of monitor resources"
}

variable "cassandra" {
  type        = map
  description = "The provisioning settings of cassandra cluster"
}

variable "scalardl" {
  type        = map
  description = "The provisioning settings of scalardl cluster"
}

variable "monitor" {
  type        = map
  default     = {}
  description = "The custom settings of monitor resources"
}

variable "slack_webhook_url" {
  default     = ""
  description = "The Webhook URL of Slack For Alerting"
}
