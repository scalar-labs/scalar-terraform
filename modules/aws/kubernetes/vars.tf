variable "network" {
  type        = map
  default     = {}
  description = "Custom definition for network and bastion"
}

variable "use_fargate_profile" {
  type        = bool
  default     = false
  description = "Custom definition kubernetes node pool that use fargate profile flag"
}

variable "kubernetes_cluster" {
  type        = map
  default     = {}
  description = "Custom definition kubernetes properties that include name of the cluster, kubernetes version, etc.."
}

variable "kubernetes_node_groups" {
  description = "Map of map of node groups to create"
  type        = any
  default = {
    default_node_pool = {}
    scalar_apps_pool  = {}
  }
}

variable "kubernetes_fargate_profiles" {
  description = "Fargate profiles to create"
  type        = any
  default = {
    default_node_pool = {}
    scalar_apps_pool  = {}
    monitoring_pool   = {}
  }
}

variable "custom_tags" {
  type        = map
  default     = {}
  description = "The map of custom tags"
}
