# General Settings
variable "name" {}

variable "location" {}

variable "public_key_path" {}

variable "private_key_path" {}

variable "internal_root_dns" {}

variable "network" {
  type    = map
  default = {}
}
