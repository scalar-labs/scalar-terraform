variable "base" {
  default     = "default"
  description = "The base of scalardl cluster"
}

variable "network" {
  type        = map
  description = "The network settings of scalardl cluster"
}

variable "cassandra" {
  type        = map
  description = "The provisioning settings of cassandra cluster"
}

variable "scalardl" {
  type        = map
  default     = {}
  description = "The custom settings of scalardl cluster"
}

variable "envoy" {
  type        = map
  default     = {}
  description = "The custom settings of envoy cluster"
}
