variable "base" {
  type        = string
  default     = "default"
  description = "The base of a scalardl cluster"
}

variable "network" {
  type        = map(string)
  description = "The network settings of a scalardl cluster"
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
