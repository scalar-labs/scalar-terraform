# General Settings
variable "region" {}

variable "name" {}

variable "locations" {
  type = list(string)
}

variable "public_key_path" {}

variable "private_key_path" {}

variable "internal_domain" {}

variable "additional_public_keys_path" {}

variable "network" {
  type    = map
  default = {}
}
