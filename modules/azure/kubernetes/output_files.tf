resource "local_file" "kubeconfig" {
  content         = local.kubeconfig
  filename        = "kube_config"
  file_permission = "0644"
}

resource "local_file" "k8s_ssh_config" {
  content         = local.k8s_ssh_config
  filename        = "k8s_ssh.cfg"
  file_permission = "0644"
}
