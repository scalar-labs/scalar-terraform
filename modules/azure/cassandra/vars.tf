variable "base" {
  default     = "default"
  description = "The base of Cassandra cluster"
}

variable "network" {
  type        = map(any)
  description = "The network settings of Cassandra cluster"
}

variable "cassandra" {
  type        = map(any)
  default     = {}
  description = "The custom settings of Cassandra cluster"
}

variable "cassy" {
  type        = map(any)
  default     = {}
  description = "The custom settings of Cassy resources"
}

variable "reaper" {
  type        = map(any)
  default     = {}
  description = "The custom settings of Reaper resources"
}
