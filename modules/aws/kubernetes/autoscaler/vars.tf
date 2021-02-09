variable "cluster_name" {
  type        = string
  description = "The name of the cluster"
}

variable "cluster_identity_oidc_issuer" {
  type        = string
  description = "The OIDC Identity issuer for the cluster"
}

variable "cluster_identity_oidc_issuer_arn" {
  type        = string
  description = "The OIDC Identity issuer ARN for the cluster that can be used to associate IAM roles with a service account"
}

variable "enabled" {
  type        = bool
  default     = false
  description = "Variable indicating whether deployment is enabled"
}

variable "region" {
  type        = string
  description = "The region"
}

variable "helm_chart_name" {
  type        = string
  default     = "cluster-autoscaler-chart"
  description = "Helm chart name to be installed"
}

variable "helm_chart_version" {
  type        = string
  default     = "1.1.1"
  description = "Version of the Helm chart"
}

variable "helm_release_name" {
  type        = string
  default     = "cluster-autoscaler"
  description = "Helm release name"
}

variable "helm_repo_url" {
  type        = string
  default     = "https://kubernetes.github.io/autoscaler"
  description = "Helm repository"
}

variable "k8s_service_account_name" {
  default     = "cluster-autoscaler"
  description = "The k8s cluster-autoscaler service account name"
}

variable "settings" {
  type        = map(any)
  default     = {}
  description = "Additional settings which will be passed to the Helm chart values, see https://artifacthub.io/packages/helm/cluster-autoscaler/cluster-autoscaler-chart"
}

variable "mod_depends_on" {
  type        = any
  default     = null
  description = "List of references to other resources this submodule depends on"
}
