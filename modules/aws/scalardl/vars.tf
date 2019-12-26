variable "base" {
  default     = "default"
  description = "The base of scalardl"
}

variable "network" {
  type = map
}

variable "cassandra" {
  type = map
}

variable "scalardl" {
  type    = map
  default = {}
}

variable "envoy" {
  type    = map
  default = {}
}
