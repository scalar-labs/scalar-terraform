# Required Variable
variable "name" {
  description = "A short name to attach to resources"
}

variable "azs" {
  type = list(string)
  default = [
    "ap-northeast-1a",
    "ap-northeast-1c",
    "ap-northeast-1d",
  ]
  description = "The AWS availability zone to deploy environment `ap-northeast-1a`"
}

variable "public_key_path" {
  description = "The path to a public key file ~/.ssh/key.pub"
}

variable "private_key_path" {
  description = "The path to a private key file ~/.ssh/key.pem"
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
