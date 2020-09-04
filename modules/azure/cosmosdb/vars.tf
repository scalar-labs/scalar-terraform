variable "base" {
  default     = "default"
  description = "The base of Cosmos DB"
}

variable "network" {
  type        = map
  description = "The network settings of Cosmos DB"
}

variable "kubernetes" {
  type        = map
  description = "The kubernetes settings of Cosmos DB"
}

variable "cosmosdb" {
  type        = map
  default     = {}
  description = "The custom settings of Cosmos DB"
}
