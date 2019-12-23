# General Settings
variable "region" {}

variable "base" {
  default = "default"
}

variable "cassandra" {
  type = map
}

variable "cassy" {
  type = map
}

variable "reaper" {
  type = map
}
