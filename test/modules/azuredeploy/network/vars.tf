# General Settings
variable "name" {
  default = "Terratest"
}

variable "location" {
  default = "West US"
}

variable "public_key_path" {
  default = "../../test_key.pub"
}

variable "private_key_path" {
  default = "../../test_key"
}

variable "public_key_folder_path" {
  default = "./public_key"
}

variable "internal_domain" {
  default = "internal.scalar-labs.com"
}

variable "network" {
  type    = map
  default = {}
}
