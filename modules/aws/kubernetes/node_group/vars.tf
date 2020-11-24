variable "cluster_name" {
  description = "Name of parent cluster"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}

variable "node_group" {
  description = "A map of `eks_node_group` to create."
  type        = any
  default     = {}
}

variable "ng_depends_on" {
  description = "List of references to other resources this submodule depends on"
  type        = any
  default     = null
}

variable "kubernetes_labels" {
  description = "List of kubernetes labels"
  type        = map(string)
  default     = {}
}

variable "create_enable" {
  description = "Flag for create node group resources."
  type        = bool
  default     = false
}
