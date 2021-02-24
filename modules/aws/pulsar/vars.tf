variable "base" {
  default     = "default"
  description = "The base of Pulsar cluster"
}

variable "network" {
  type        = map(string)
  description = "The network settings of Pulsar cluster"
}

variable "bookie" {
  type        = map(string)
  default     = {}
  description = "The bookie settings of Pulsar cluster"
}

variable "broker" {
  type        = map(string)
  default     = {}
  description = "The broker settings of Pluster cluster"
}

variable "zookeeper" {
  type        = map(string)
  default     = {}
  description = "The zookeeper settings of Pluster cluster"
}

variable "custom_tags" {
  type        = map(string)
  default     = {}
  description = "The map of custom tags"
}
