variable "base" {
  default     = "default"
  description = "The base of a scalardl cluster"
}

variable "network" {
  type        = map(string)
  description = "The network settings of a scalardl cluster"
}

variable "cassandra" {
  type        = map(string)
  description = "The provisioning settings of a cassandra cluster"
}

variable "scalardl" {
  type        = map(string)
  default     = {}
  description = "The custom settings of a scalardl cluster"
}

variable "envoy" {
  type        = map(string)
  default     = {}
  description = "The custom settings of an envoy cluster"
}
