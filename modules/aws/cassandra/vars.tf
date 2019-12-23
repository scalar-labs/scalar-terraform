variable "base" {
  default     = "default"
  description = "The base of cassandra"
}

variable "network" {
  type        = map(string)
  description = "The network settings of cassandra"
}

variable "cassandra" {
  default     = {}
  description = "The cluster settings of cassandra"
}

variable "cassy" {
  default     = {}
  description = "The cluster settings of cassy"
}

variable "reaper" {
  default     = {}
  description = "The cluster settings of reaper"
}
