# General Settings
variable "region" {
  default = "us-east-1"
}

variable "base" {
  default = "default"
}

variable "bookie" {
  type    = map
  default = {}
}

variable "broker" {
  type    = map
  default = {}
}

variable "zookeeper" {
  type    = map
  default = {}
}
