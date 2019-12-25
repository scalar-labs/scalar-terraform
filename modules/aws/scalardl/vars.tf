variable "base" {
  default = "default"
  description = "The base of scalardl"
}

variable "network" {
  type    = map
  default = {}
}

variable "scalardl" {
  type    = map
  default = {}
}

variable "envoy" {
  type    = map
  default = {}
}
