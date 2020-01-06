variable "network" {
  type        = map
  description = "The network settings"
}

variable "ca" {
  type        = map
  default     = {}
  description = "The ca settings"
}
