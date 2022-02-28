# Required Variable
variable "base" {
  type        = string
  default     = "default"
  description = "The base of network"
}

variable "name" {
  type        = string
  description = "A short name to attach to resources"
}

variable "region" {
  type        = string
  description = "The Azure region to deploy environment"
}

variable "locations" {
  type        = tolist(string)
  default     = []
  description = "The Azure availability zones to deploy environment"
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

variable "use_cosmosdb" {
  type        = bool
  default     = false
  description = "Whether to use Cosmos DB. If true, a service endpoint for Cosmos DB is enabled."
}
