variable "base" {
  default = "default"
}

variable "network" {
  type = map
}

variable "cassandra" {
  type = map
}

variable "scalardl" {
  type = map
}

variable "monitor" {
  type    = map
  default = {}
}

variable "slack_webhook_url" {}
