variable "region" {
  default = "ap-northeast-1"
}

variable "base" {
  default     = "default"
  description = "The base of Pulsar cluster"
}

variable "bookie" {
  type        = map
  default     = {}
  description = "The bookie settings of Pulsar cluster"
}

variable "broker" {
  type        = map
  default     = {}
  description = "The broker settings of Pulsar cluster"
}

variable "zookeeper" {
  type        = map
  default     = {}
  description = "The zookeeper settings of Pulsar cluster"
}

variable "custom_tags" {
  type        = map(string)
  default     = {}
  description = "The map of custom tags"
}
