resource "local_file" "kubeconfig" {
  content         = local.kubeconfig
  filename        = local.kubeconfig_name
  file_permission = "0644"
}
