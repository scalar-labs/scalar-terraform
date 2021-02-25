variable "cluster_name" {
  type        = string
  description = "Name of parent cluster"
}

variable "tags" {
  type        = map(string)
  description = "A map of tags to add to all resources"
}

variable "node_group" {
  description = "A map of `eks_node_group` to create."
  type        = map(any)
  default     = {}
}

variable "ng_depends_on" {
  type        = any
  description = "List of references to other resources this submodule depends on"
  default     = null
}

variable "kubernetes_labels" {
  type        = map(string)
  default     = {}
  description = "List of kubernetes labels"
}

variable "create_enable" {
  type        = bool
  default     = false
  description = "Flag for create node group resources."
}
