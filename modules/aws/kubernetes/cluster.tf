resource "aws_cloudwatch_log_group" "eks_cluster" {
  count = length(local.kubernetes_cluster.cluster_enabled_log_types)

  name              = "/aws/eks/${local.network_name}/cluster"
  retention_in_days = local.kubernetes_cluster.cluster_log_retention_in_days

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

  enabled_cluster_log_types = local.kubernetes_cluster.cluster_enabled_log_types

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
    endpoint_private_access = local.kubernetes_cluster.cluster_endpoint_private_access
    endpoint_public_access  = local.kubernetes_cluster.cluster_endpoint_public_access
    public_access_cidrs     = local.kubernetes_cluster.cluster_endpoint_public_access_cidrs
  }

  timeouts {
    create = local.kubernetes_cluster.cluster_create_timeout
    delete = local.kubernetes_cluster.cluster_delete_timeout
  }

  dynamic encryption_config {
    for_each = toset(local.kubernetes_cluster.cluster_encryption_config)

    content {
      provider {
        key_arn = encryption_config.value["provider_key_arn"]
      }
      resources = encryption_config.value["resources"]
    }
  }

  depends_on = [
  ]
}
