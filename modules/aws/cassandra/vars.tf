variable "base" {
  default     = "default"
  description = "The base of Cassandra cluster"
}

variable "network" {
  type        = map(string)
  description = "The network settings of Cassandra cluster"
}

variable "cassandra" {
  type        = map(string)
  default     = {}
  description = "The custom settings of Cassandra cluster"
}

variable "cassy" {
  type        = map(string)
  default     = {}
  description = "The custom settings of Cassy resources"
}

variable "reaper" {
  type        = map(string)
  default     = {}
  description = "The custom settings of Reaper resources"
}

variable "custom_tags" {
  type        = map(string)
  default     = {}
  description = "The map of custom tags"
}
