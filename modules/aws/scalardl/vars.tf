variable "base" {
  default     = "default"
  description = "The base of a scalardl cluster"
}

variable "network" {
  type        = map
  description = "The network settings of a scalardl cluster"
}

variable "cassandra" {
  type        = map
  description = "The provisioning settings of a cassandra cluster"
}

variable "scalardl" {
  type        = map
  default     = {}
  description = "The custom settings of a scalardl cluster"
}

variable "envoy" {
  type        = map
  default     = {}
  description = "The custom settings of a envoy cluster"
}
