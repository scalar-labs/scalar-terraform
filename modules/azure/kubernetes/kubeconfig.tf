resource "local_file" "kubeconfig" {
  content              = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw
  filename             = "kube_config"
  file_permission      = "0644"
  directory_permission = "0755"
}
