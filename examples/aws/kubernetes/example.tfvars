# Optional
kubernetes_cluster = {
  # name                                 = "scalar-kubernetes"
  # kubernetes_version                   = "1.16"
  # cluster_enabled_log_types            = ""
  # cluster_log_retention_in_days        = "90"
  # cluster_log_kms_key_id               = ""
  # cluster_endpoint_private_access      = "true"
  # cluster_endpoint_public_access       = "false"
  # cluster_endpoint_public_access_cidrs = "0.0.0.0/0"
  # cluster_create_timeout               = "30m"
  # cluster_delete_timeout               = "15m"
  # cluster_encryption_config_enabled    = "false"
  # cluster_encryption_config_resources  = ""
  # cluster_encryption_config_kms_key_id = ""
  # use_fargate_profile                  = "false"
}

kubernetes_node_groups = {
  default_node_pool = {
    # name                           = "default"
    # node_count                     = "3"
    # vm_size                        = "m5.large"
    # os_disk_size_gb                = "64"
    # cluster_auto_scaling_min_count = "3"
    # cluster_auto_scaling_max_count = "6"
  }

  scalar_apps_pool = {
    # name                           = "scalardlpool"
    # node_count                     = "3"
    # vm_size                        = "m5.large"
    # os_disk_size_gb                = "64"
    # cluster_auto_scaling_min_count = "3"
    # cluster_auto_scaling_max_count = "6"
  }
}

custom_tags = {
  # "environment" = "example"
}
