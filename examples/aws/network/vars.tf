# General Settings
variable "region" {
  default = "ap-northeast-1"
}

variable "name" {}

variable "location" {}

variable "public_key_path" {}

variable "private_key_path" {}

variable "internal_root_dns" {}

variable "network" {
  type    = map
  default = {}
}
