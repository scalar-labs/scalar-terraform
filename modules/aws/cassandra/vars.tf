variable "base" {
  default     = "default"
  description = "The base of cassandra cluster"
}

variable "network" {
  type        = map
  description = "The network settings of cassandra cluster"
}

variable "cassandra" {
  type        = map
  default     = {}
  description = "The custom settings of cassandra cluster"
}

variable "cassy" {
  type        = map
  default     = {}
  description = "The custom settings of cassy resources"
}

variable "reaper" {
  type        = map
  default     = {}
  description = "The custom settings of reaper resources"
}
