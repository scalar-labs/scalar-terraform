variable "network" {
  type        = map(string)
  description = "The network settings of CA resource"
}

variable "ca" {
  type        = map(string)
  default     = {}
  description = "The custom settings of CA resource"
}
