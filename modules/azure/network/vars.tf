# Required Variable
variable "name" {
  description = "A short name to attach to resources"
}

variable "location" {
  description = "The Azure location to deploy environment"
}

variable "public_key_path" {
  description = "The path to a public key file ~/.ssh/key.pub"
}

variable "private_key_path" {
  description = "The path to a private key file ~/.ssh/key.pem"
}

variable "multiple_public_key_folder_path" {
  description = "The path to the multiple public key folder for SSH access."
}

variable "internal_domain" {
  description = "An internal DNS domain name to use for mapping IP addresses"
}

# Optional Variable
variable "network" {
  type        = map
  default     = {}
  description = "Custom definition for network and bastion"
}
