# General Settings
variable "name" {
  default = "Terratest"
}

variable "region" {
  default = "West US"
}

variable "locations" {
  type    = list(string)
  default = []
}

variable "public_key_path" {
  default = "../../test_key.pub"
}

variable "private_key_path" {
  default = "../../test_key"
}

variable "additional_public_keys_path" {
  default = "./additional_public_keys"
}

variable "internal_domain" {
  default = "internal.scalar-labs.com"
}

variable "network" {
  type    = map
  default = {}
}
