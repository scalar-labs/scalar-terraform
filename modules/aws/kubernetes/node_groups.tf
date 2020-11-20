module "scalardl_apps_pool" {
  source = "./node_group"

  cluster_name  = aws_eks_cluster.eks_cluster.name
  node_group    = local.kubernetes_scalar_apps_pool
  create_enable = ! local.kubernetes_cluster.use_fargate_profile

  kubernetes_labels = local.kubernetes_scalar_apps_pool.kubernetes_labels

  ng_depends_on = [
    aws_eks_cluster.eks_cluster,
  ]

  tags = merge(
    var.custom_tags,
    {
      Terraform = "true"
      Network   = local.network_name
    }
  )
}

module "default_node_pool" {
  source = "./node_group"

  cluster_name  = aws_eks_cluster.eks_cluster.name
  node_group    = local.kubernetes_default_node_pool
  create_enable = ! local.kubernetes_cluster.use_fargate_profile

  ng_depends_on = [
    module.scalardl_apps_pool,
  ]

  tags = merge(
    var.custom_tags,
    {
      Terraform = "true"
      Network   = local.network_name
    }
  )
}
