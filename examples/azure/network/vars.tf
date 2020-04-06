# General Settings
variable "name" {}

variable "location" {}

variable "public_key_path" {}

variable "private_key_path" {}

variable "public_key_folder_path" {}

variable "internal_domain" {}

variable "network" {
  type    = map
  default = {}
}
