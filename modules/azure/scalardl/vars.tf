variable "base" {
  default     = "default"
  description = "The base of a scalardl cluster"
}

variable "network" {
  type        = map(any)
  description = "The network settings of a scalardl cluster"
}

variable "cassandra" {
  type        = map(any)
  description = "The provisioning settings of a cassandra cluster"
}

variable "scalardl" {
  type        = map(any)
  default     = {}
  description = "The custom settings of a scalardl cluster"
}

variable "envoy" {
  type        = map(any)
  default     = {}
  description = "The custom settings of an envoy cluster"
}
