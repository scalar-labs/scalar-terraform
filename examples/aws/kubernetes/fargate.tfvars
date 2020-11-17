# Optional
use_fargate_profile = true

kubernetes_cluster = {
  # name                                 = "scalar-kubernetes"
  # kubernetes_version                   = "1.16"
  # kube_dashboard                       = "true"
  # cluster_enabled_log_types            = ""
  # cluster_endpoint_private_access      = true
  # cluster_endpoint_public_access       = false
  # cluster_endpoint_public_access_cidrs = "0.0.0.0/0"
  # cluster_create_timeout               = "30m"
  # cluster_delete_timeout               = "15m"
  # cluster_encryption_config_enabled    = "false"
  # cluster_encryption_config_resources  = ""
  # cluster_encryption_config_kms_key_id = ""
}

kubernetes_fargate_profiles = {
  default_node_pool = {
    # namespace         = "default"
    # kubernetes_labels = {}
  }

  scalar_apps_pool = {
    # namespace  = "default"

    # kubernetes_labels = {
    #   agentpool = "scalardlpool"
    # }
  }

  monitoring_pool = {
    # namespace         = "monitoring"
    # kubernetes_labels = {}
  }
}

custom_tags = {
  # "environment" = "example"
}
