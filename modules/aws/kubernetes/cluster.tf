locals {
  cluster_encryption_config = {
    resources        = local.kubernetes_cluster.cluster_encryption_config_resources
    provider_key_arn = local.kubernetes_cluster.cluster_encryption_config_kms_key_id
  }

  enabled_cluster_log_types = length(local.kubernetes_cluster.cluster_enabled_log_types) > 0 ? split(",", local.kubernetes_cluster.cluster_enabled_log_types) : []
}

resource "aws_cloudwatch_log_group" "eks_cluster" {
  count = length(local.kubernetes_cluster.cluster_enabled_log_types)

  name              = "/aws/eks/${local.network_name}/cluster"
  retention_in_days = local.kubernetes_cluster.cluster_log_retention_in_days
  kms_key_id        = local.kubernetes_cluster.cluster_log_kms_key_id

  tags = merge(
    var.custom_tags,
    {
      Terraform = "true"
      Network   = local.network_name
    }
  )
}

resource "aws_eks_cluster" "eks_cluster" {
  name     = local.network_name
  role_arn = aws_iam_role.eks_cluster.arn
  version  = local.kubernetes_cluster.kubernetes_version

  enabled_cluster_log_types = local.enabled_cluster_log_types

  tags = merge(
    var.custom_tags,
    {
      Terraform = "true"
      Network   = local.network_name
    }
  )

  vpc_config {
    security_group_ids      = compact([aws_security_group.eks_cluster.id])
    subnet_ids              = local.kubernetes_cluster.subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = local.kubernetes_cluster.public_cluster_enabled
    public_access_cidrs     = local.kubernetes_cluster.public_cluster_enabled ? split(",", local.kubernetes_cluster.cluster_endpoint_public_access_cidrs) : null
  }

  timeouts {
    create = local.kubernetes_cluster.cluster_create_timeout
    delete = local.kubernetes_cluster.cluster_delete_timeout
  }

  dynamic "encryption_config" {
    for_each = local.kubernetes_cluster.cluster_encryption_config_enabled ? [local.cluster_encryption_config] : []

    content {
      resources = encryption_config.value["provider_key_arn"]
      provider {
        key_arn = encryption_config.value["provider_key_arn"]
      }
    }
  }

  depends_on = [
  ]
}
