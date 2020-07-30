variable "network_id" {
  description = "The network ID to create DNS zone"
}

variable "network_name" {
  description = "The network name to attach to resource"
}

variable "internal_domain" {
  description = "An internal DNS domain name to use for mapping IP addresses"
}

variable "custom_tags" {
  type        = map
  default     = {}
  description = "The map of custom tags"
}

variable "custom_vpc_ids" {
  type        = list
  default     = []
  description = "The map of custom vpc ids"
}
