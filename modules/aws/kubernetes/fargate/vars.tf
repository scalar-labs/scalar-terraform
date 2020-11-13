variable "name" {
  description = "Name of the EKS fargate pods."
  type        = string
}

variable "cluster_name" {
  description = "Name of the EKS cluster."
  type        = string
}

variable "namespace" {
  description = "Namespace of the EKS fargate pods."
  type        = string
}

variable "kubernetes_labes" {
  description = "A map of kubernetes labes."
  type        = map(string)
  default     = {}
}

variable "subnets" {
  description = "A list of subnets for the EKS Fargate profiles."
  type        = list(string)
  default     = []
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "eks_depends_on" {
  description = "List of references to other resources this submodule depends on."
  type        = any
  default     = null
}

variable "create_fargate" {
  description = "Flag for create fargate resources."
  type        = bool
  default     = false
}
