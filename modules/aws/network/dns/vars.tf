variable "network_id" {
  type        = string
  description = "The network ID to create DNS zone"
}

variable "network_name" {
  type        = string
  description = "The network name to attach to resource"
}

variable "internal_domain" {
  type        = string
  description = "An internal DNS domain name to use for mapping IP addresses"
}

variable "custom_tags" {
  type        = map(string)
  default     = {}
  description = "The map of custom tags"
}
