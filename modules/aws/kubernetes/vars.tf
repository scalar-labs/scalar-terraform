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

variable "kubernetes_default_node_pool" {
  type        = map
  default     = {}
  description = "Custom definition kubernetes default node pool that include number of node, node size, autoscaling, etc.."
}

variable "kubernetes_scalar_apps_pool" {
  type        = map
  default     = {}
  description = "Custom definition kubernetes scalar apps node pool, same as default_node_pool"
}

variable "kubernetes_fargate_profiles" {
  description = "Fargate profiles to create"
  type        = any
  default     = {}
}

variable "custom_tags" {
  type        = map
  default     = {}
  description = "The map of custom tags"
}
