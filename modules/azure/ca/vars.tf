variable "network" {
  type        = map(any)
  description = "The network settings of CA resource"
}

variable "ca" {
  type        = map(any)
  default     = {}
  description = "The custom settings of CA resource"
}
