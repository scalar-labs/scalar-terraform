# Optional
kubernetes_cluster = {
  # name                                 = "scalar-kubernetes"
  # kubernetes_version                   = "1.16"
  # kube_dashboard                       = true
  # cluster_enabled_log_types            = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  # cluster_endpoint_private_access      = true
  # cluster_endpoint_public_access       = false
  # cluster_endpoint_public_access_cidrs = ["0.0.0.0/0"]
  # cluster_create_timeout               = "30m"
  # cluster_delete_timeout               = "15m"
  # cluster_encryption_config            = []
}

kubernetes_default_node_pool = {
  # name                           = "default"
  # node_count                     = "3"
  # vm_size                        = "m5.large"
  # os_disk_size_gb                = "64"
  # cluster_auto_scaling_min_count = "3"
  # cluster_auto_scaling_max_count = "6"
}

kubernetes_scalar_apps_pool = {
  # name                           = "scalardlpool"
  # node_count                     = "3"
  # vm_size                        = "m5.large"
  # os_disk_size_gb                = "64"
  # cluster_auto_scaling_min_count = "3"
  # cluster_auto_scaling_max_count = "6"
}

custom_tags = {
  # "environment" = "example"
}