variable "network" {
  type        = map
  description = "The network settings of Cosmos DB"
}

variable "allowed_subnet_ids" {
  type        = list
  description = "The subnet IDs to allow access to Cosmos DB"
}
