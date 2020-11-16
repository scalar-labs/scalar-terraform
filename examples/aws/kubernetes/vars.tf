# General Settings
variable "region" {
  default = "ap-northeast-1"
}

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

variable "kubernetes_fargate_profiles" {
  type        = any
  default     = {}
  description = "Fargate profiles to create"
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
  description = "Custom definition kubernetes scalar apps node pools, same as default_node_pool"
}

variable "custom_tags" {
  type    = map
  default = {}
}
