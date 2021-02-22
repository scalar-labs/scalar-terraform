variable "network" {
  type        = map(any)
  description = "The network settings of Cosmos DB"
}

variable "allowed_subnet_ids" {
  type        = list(any)
  description = "The subnet IDs to allow access to Cosmos DB"
}
