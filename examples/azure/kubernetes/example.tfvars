# Optional
kubernetes_cluster = {
  # name                            = "scalar-kubernetes"
  # dns_prefix                      = "scalar-kubernetes"
  # kubernetes_version              = "1.16.13"
  # admin_username                  = "azureuser"
  # role_based_access_control       = true
  # kube_dashboard                  = true
}

kubernetes_default_node_pool = {
  # name                           = "default"
  # node_count                     = "3"
  # vm_size                        = "Standard_D2s_v3"
  # max_pods                       = "100"
  # os_disk_size_gb                = "64"
  # cluster_auto_scaling           = "true"
  # cluster_auto_scaling_min_count = "3"
  # cluster_auto_scaling_max_count = "6"
}

kubernetes_scalar_apps_pool = {
  # name                           = "scalardlpool"
  # node_count                     = "3"
  # vm_size                        = "Standard_D2s_v3"
  # max_pods                       = "100"
  # os_disk_size_gb                = "64"
  # taints                         = "kubernetes.io/app=scalardlpool:NoSchedule"
  # cluster_auto_scaling           = "true"
  # cluster_auto_scaling_min_count = "3"
  # cluster_auto_scaling_max_count = "6"
}

# use_cosmosdb = false

custom_tags = {
  # "environment" = "example"
}
