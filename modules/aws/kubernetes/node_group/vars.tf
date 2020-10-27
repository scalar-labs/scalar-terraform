variable "cluster_name" {
  description = "Name of parent cluster"
  type        = string
}

variable "iam_role_arn" {
  description = "ARN of the default IAM worker role to use if one is not specified in `var.node_groups` or `var.node_groups_defaults`"
  type        = string
}

variable "tags" {
  description = "A map of tags to add to all resources"
  type        = map(string)
}

variable "node_group" {
  description = "Map of maps of `eks_node_groups` to create. See \"`node_groups` and `node_groups_defaults` keys\" section in README.md for more details"
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
