# Required Variable
variable "base" {
  type        = string
  default     = "default"
  description = "The base of network"
}

variable "name" {
  description = "A short name to attach to resources"
}

variable "locations" {
  type        = list(string)
  description = "The AWS availability zones to deploy environment `ap-northeast-1a`"
}

variable "public_key_path" {
  type        = string
  description = "The path to a public key file ~/.ssh/key.pub"
}

variable "private_key_path" {
  type        = string
  description = "The path to a private key file ~/.ssh/key.pem"
}

variable "internal_domain" {
  type        = string
  description = "An internal DNS domain name to use for mapping IP addresses"
}

# Optional Variable
variable "network" {
  type        = map(string)
  default     = {}
  description = "Custom definition for network and bastion"
}

variable "additional_public_keys_path" {
  type        = string
  default     = ""
  description = "The path to a file that contains multiple public keys for SSH access."
}

variable "custom_tags" {
  type        = map(string)
  default     = {}
  description = "The map of custom tags"
}
