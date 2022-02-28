variable "network" {
  type        = map(string)
  description = "The network settings of Cosmos DB"
}

variable "enable_virtual_network_filter" {
  type        = bool
  description = "A flag to enable virtual network filtering for Cosmos DB"
  default     = true
}

variable "allowed_subnet_ids" {
  type        = tolist(string)
  description = "The subnet IDs to allow access to Cosmos DB"
  default     = []
}

variable "allowed_cidrs" {
  type        = tolist(string)
  description = "IP addresses or IP address ranges in CIDR to allow access to Cosmos DB"
  default     = []
}
