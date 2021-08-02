variable "network" {
  type        = map(string)
  description = "The network settings of Cosmos DB"
}

variable "is_virtual_network_filter_enabled" {
  type        = bool
  description = "A flag to enable virtual network filtering for Cosmos DB"
  default     = true
}

variable "allowed_subnet_ids" {
  type        = list(string)
  description = "The subnet IDs to allow access to Cosmos DB"
  default     = []
}

variable "allowed_cidrs" {
  type        = list(string)
  description = "IP addresses or IP address ranges in CIDR to allow access to Cosmos DB"
  default     = []
}
