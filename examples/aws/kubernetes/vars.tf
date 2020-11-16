# General Settings
variable "region" {
  default = "ap-northeast-1"
}

variable "network" {
  type    = map
  default = {}
}

variable "use_fargate_profile" {
  type    = bool
  default = false
}

variable "kubernetes_cluster" {
  type    = map
  default = {}
}

variable "kubernetes_node_groups" {
  type = any
  default = {
    default_node_pool = {}
    scalar_apps_pool  = {}
  }
}

variable "kubernetes_fargate_profiles" {
  type = any
  default = {
    default_node_pool = {}
    scalar_apps_pool  = {}
    monitoring_pool   = {}
  }
}

variable "custom_tags" {
  type    = map
  default = {}
}
