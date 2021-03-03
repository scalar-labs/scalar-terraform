output "node_pool_subnet_id" {
  value = azurerm_subnet.k8s_private["k8s_node_pod"].id
}

output "kube_config" {
  value       = local.kubeconfig
  description = "kubectl configuration e.g: ~/.kube/config"
}

output "k8s_ssh_config" {
  value       = local.k8s_ssh_config
  description = "The configuration file for K8s API local port forward and SSH K8s Nodes access."
}
