output "kube_config" {
  description = "kubectl configuration e.g: ~/.kube/config"
  value       = local.kubeconfig
}

output "config_map_aws_auth" {
  description = "A kubernetes configuration to authenticate to this EKS cluster."
  value       = kubernetes_config_map.aws_auth.*
}
