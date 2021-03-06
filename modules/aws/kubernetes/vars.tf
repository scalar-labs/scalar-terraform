variable "network" {
  type        = map(string)
  default     = {}
  description = "Custom definition for network and bastion"
}

variable "kubernetes_cluster" {
  type        = map(string)
  default     = {}
  description = "Custom definition kubernetes properties that include the name of the cluster, kubernetes version, etc.."
}

variable "kubernetes_node_groups" {
  description = "Map of map of node groups to create"
  type        = any
  default = {
    default_node_pool = {}
    scalar_apps_pool  = {}
  }
}

variable "custom_tags" {
  type        = map(string)
  default     = {}
  description = "The map of custom tags"
}
