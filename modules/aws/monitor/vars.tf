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
  default     = {}
  description = "The provisioning settings of a cassandra cluster"
}

variable "scalardl" {
  type        = map
  default     = {}
  description = "The provisioning settings of a scalardl cluster"
}

variable "monitor" {
  type        = map
  default     = {}
  description = "The custom settings of monitor resources"
}

variable "target_monitoring" {
  type        = list(string)
  default     = []
  description = "The target monitoring"
}

variable "slack_webhook_url" {
  default     = ""
  description = "The Webhook URL of Slack for alerting"
}

variable "custom_tags" {
  type        = map(string)
  default     = {}
  description = "The map of custom tags"
}
