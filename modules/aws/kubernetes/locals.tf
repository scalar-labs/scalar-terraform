# General network
locals {
  network_name       = var.network.name
  network_cidr       = var.network.cidr
  network_id         = var.network.id
  subnet_ids         = split(",", var.network.subnet_ids)
  public_subnet_ids  = split(",", var.network.public_subnet_ids)
  private_subnet_ids = split(",", var.network.private_subnet_ids)
  bastion_ip         = var.network.bastion_ip
  user_name          = var.network.user_name
  region             = var.network.region
}

locals {
  kubernetes_cluster_default = {
    name                                 = "scalar-kubernetes"
    kubernetes_version                   = "1.19"
    cluster_enabled_log_types            = "" # api,audit,authenticator,controllerManager,scheduler
    cluster_log_retention_in_days        = 90
    cluster_log_kms_key_id               = ""
    cluster_endpoint_public_access_cidrs = "0.0.0.0/0"
    cluster_create_timeout               = "30m"
    cluster_delete_timeout               = "15m"
    cluster_encryption_config_enabled    = false
    cluster_encryption_config_resources  = ""
    cluster_encryption_config_kms_key_id = ""
    cluster_auto_scaling                 = false
    public_cluster_enabled               = true
    aws_auth_system_master_role          = data.aws_iam_role.bastion.arn
    subnet_ids                           = concat(local.subnet_ids, local.public_subnet_ids, local.private_subnet_ids)
    use_fargate_profile                  = false
    manage_aws_auth                      = true
  }

  kubernetes_cluster = merge(
    local.kubernetes_cluster_default,
    var.kubernetes_cluster
  )
}

locals {
  kubernetes_node_pool = {
    name                           = "default"
    node_count                     = "3"
    ami_type                       = "AL2_x86_64"
    instance_type                  = "m5.large"
    os_disk_size_gb                = "64"
    cluster_auto_scaling_min_count = "3"
    cluster_auto_scaling_max_count = "6"
    subnet_ids                     = local.private_subnet_ids
    kubernetes_labels              = {}
    enable_remote_access           = true
    ssh_key_name                   = var.network.ssh_key_name
    source_security_group_ids      = [var.network.bastion_security_group_id]
  }

  kubernetes_default_node_pool = merge(
    local.kubernetes_node_pool,
    var.kubernetes_node_groups.default_node_pool
  )
}

locals {
  scalar_apps_pool = {
    name                           = "scalardlpool"
    node_count                     = "3"
    ami_type                       = "AL2_x86_64"
    instance_type                  = "m5.large"
    os_disk_size_gb                = "64"
    cluster_auto_scaling_min_count = "3"
    cluster_auto_scaling_max_count = "6"
    subnet_ids                     = local.subnet_ids
    kubernetes_labels = {
      agentpool = "scalardlpool"
    }
    enable_remote_access      = true
    ssh_key_name              = var.network.ssh_key_name
    source_security_group_ids = [var.network.bastion_security_group_id]
  }

  kubernetes_scalar_apps_pool = merge(
    local.scalar_apps_pool,
    var.kubernetes_node_groups.scalar_apps_pool
  )
}

locals {
  policy_arn_prefix = "arn:${data.aws_partition.current.partition}:iam::aws:policy"

  kubeconfig_name = "kube_config"

  kubeconfig = templatefile("${path.module}/templates/kubeconfig.tpl",
    {
      kubeconfig_name                   = local.kubeconfig_name
      endpoint                          = aws_eks_cluster.eks_cluster.endpoint
      cluster_auth_base64               = aws_eks_cluster.eks_cluster.certificate_authority[0].data
      aws_authenticator_command         = "aws"
      aws_authenticator_command_args    = ["eks", "get-token", "--cluster-name", aws_eks_cluster.eks_cluster.name]
      aws_authenticator_additional_args = ["--region", local.region]
      aws_authenticator_env_variables   = []
    }
  )
}
