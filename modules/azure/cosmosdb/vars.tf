variable "network" {
  type        = map(string)
  description = "The network settings of Cosmos DB"
}

variable "allowed_subnet_ids" {
  type        = list(string)
  description = "The subnet IDs to allow access to Cosmos DB"
}
