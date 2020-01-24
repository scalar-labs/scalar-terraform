variable "network" {
  type        = map
  description = "The network settings of CA resource"
}

variable "ca" {
  type        = map
  default     = {}
  description = "The custom settings of CA resource"
}
