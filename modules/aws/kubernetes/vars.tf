variable "network" {
  type        = map
  default     = {}
  description = "Custom definition for network and bastion"
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

variable "kubernetes_default_fargate" {
  type        = map
  default     = {}
  description = "Custom definition kubernetes default fargate profile"
}

variable "kubernetes_scalar_apps_fargate" {
  type        = map
  default     = {}
  description = "Custom definition kubernetes scalar apps fargate profile"
}

variable "custom_tags" {
  type        = map
  default     = {}
  description = "The map of custom tags"
}