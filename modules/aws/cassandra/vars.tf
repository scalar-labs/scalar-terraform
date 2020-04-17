variable "base" {
  default     = "default"
  description = "The base of Cassandra cluster"
}

variable "network" {
  type        = map
  description = "The network settings of Cassandra cluster"
}

variable "cassandra" {
  type        = map
  default     = {}
  description = "The custom settings of Cassandra cluster"
}

variable "cassy" {
  type        = map
  default     = {}
  description = "The custom settings of Cassy resources"
}

variable "cassy_storage_base_uri" {
  type        = string
  description = "The storage_base_uri that Cassy uses to store Cassandra backups. The URI must be in s3://<your-bucket-name> form."
}

variable "reaper" {
  type        = map
  default     = {}
  description = "The custom settings of Reaper resources"
}

variable "custom_tags" {
  type        = map(string)
  default     = {}
  description = "The map of custom tags"
}
