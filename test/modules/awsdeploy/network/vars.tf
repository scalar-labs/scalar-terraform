# General Settings
variable "region" {}

variable "name" {}

variable "locations" {
  type = list
}

variable "public_key_path" {}

variable "private_key_path" {}

variable "internal_domain" {}

variable "network" {
  type    = map
  default = {}
}
