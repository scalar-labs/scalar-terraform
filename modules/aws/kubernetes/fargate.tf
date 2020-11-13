module "scalardl_apps_fargate" {
  source = "./fargate"

  name         = "scalardl"
  cluster_name = aws_eks_cluster.eks_cluster.name
  subnets      = local.kubernetes_scalar_apps_fargate.subnet_ids
  namespace    = local.kubernetes_scalar_apps_fargate.namespace

  tags = var.custom_tags

  eks_depends_on = [
    aws_eks_cluster.eks_cluster,
    kubernetes_config_map.aws_auth,
  ]
}

module "default_fargate" {
  source = "./fargate"

  name         = "default"
  cluster_name = aws_eks_cluster.eks_cluster.name
  subnets      = local.kubernetes_default_fargate.subnet_ids
  namespace    = local.kubernetes_default_fargate.namespace

  tags = var.custom_tags

  eks_depends_on = [
    aws_eks_cluster.eks_cluster,
    kubernetes_config_map.aws_auth,
  ]
}

module "monitoring_fargate" {
  source = "./fargate"

  name         = "monitoring"
  cluster_name = aws_eks_cluster.eks_cluster.name
  subnets      = local.kubernetes_monitoring_fargate.subnet_ids
  namespace    = local.kubernetes_monitoring_fargate.namespace

  tags = var.custom_tags

  eks_depends_on = [
    aws_eks_cluster.eks_cluster,
    kubernetes_config_map.aws_auth,
  ]
}
