# General Settings
variable "region" {
  default = "us-east-1"
}

variable "base" {
  default = "default"
}

variable "scalardl" {
  type    = map
  default = {}
}

variable "envoy" {
  type    = map
  default = {}
}
