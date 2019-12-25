variable "base" {
  default     = "default"
  description = "The base of cassandra"
}

variable "network" {
  type        = map
  description = "The network settings of cassandra"
}

variable "cassandra" {
  type        = map
  default     = {}
  description = "The cluster settings of cassandra"
}

variable "cassy" {
  type        = map
  default     = {}
  description = "The cluster settings of cassy"
}

variable "reaper" {
  type        = map
  default     = {}
  description = "The cluster settings of reaper"
}
