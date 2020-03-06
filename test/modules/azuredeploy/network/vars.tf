# General Settings
variable "name" {
  default = "Terratest"
}

variable "location" {
  default = "West US 2"
}

variable "public_key_path" {
  default = "../../test_key.pub"
}

variable "private_key_path" {
  default = "../../test_key"
}

variable "internal_root_dns" {
  default = "internal.scalar-labs.com"
}

variable "network" {
  type    = map
  default = {}
}
