# General Settings
variable "region" {
  default = "ap-northeast-1"
}

variable "name" {}

variable "azs" {
  type = list(string)
  default = [
    "ap-northeast-1a",
    "ap-northeast-1c",
    "ap-northeast-1d",
  ]
}

variable "public_key_path" {}

variable "private_key_path" {}

variable "internal_domain" {}

variable "network" {
  type    = map
  default = {}
}
