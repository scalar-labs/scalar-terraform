variable "base" {
  default     = "default"
  description = "The base of monitor resources"
}

variable "network" {
  type        = map(any)
  description = "The network settings of monitor resources"
}

variable "cassandra" {
  type        = map(any)
  default     = {}
  description = "The provisioning settings of a cassandra cluster"
}

variable "scalardl" {
  type        = map(any)
  default     = {}
  description = "The provisioning settings of a scalardl cluster"
}

variable "monitor" {
  type        = map(any)
  default     = {}
  description = "The custom settings of monitor resources"
}

variable "targets" {
  type        = list(string)
  default     = []
  description = "The target monitoring"
}

variable "slack_webhook_url" {
  default     = ""
  description = "The Webhook URL of Slack for alerting"
}
