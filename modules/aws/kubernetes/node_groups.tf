module "scalardl_apps_pool" {
  source = "./node_group"

  cluster_name = aws_eks_cluster.eks_cluster.name
  iam_role_arn = aws_iam_role.eks_node.arn
  node_group   = local.kubernetes_scalar_apps_pool

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

  cluster_name = aws_eks_cluster.eks_cluster.name
  iam_role_arn = aws_iam_role.eks_node.arn
  node_group   = local.kubernetes_default_node_pool

  tags = merge(
    var.custom_tags,
    {
      Terraform = "true"
      Network   = local.network_name
    }
  )
}
