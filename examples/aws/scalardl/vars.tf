# General Settings
variable "region" {}

variable "base" {
  default = "default"
}

variable "scalardl" {
  type = map
}

variable "envoy" {
  type = map
}
