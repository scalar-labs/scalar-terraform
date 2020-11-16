module "kube_system" {
  source = "./fargate"

  name         = "coredns"
  cluster_name = aws_eks_cluster.eks_cluster.name
  subnets      = local.subnet_ids
  namespace    = "kube-system"
  kubernetes_labes = {
    "k8s-app"                     = "kube-dns",
    "eks.amazonaws.com/component" = "coredns"
  }
  create_enable = local.use_fargate_profile

  tags = var.custom_tags

  eks_depends_on = [
    aws_eks_cluster.eks_cluster,
  ]
}

module "default_fargate" {
  source = "./fargate"

  name             = "default"
  cluster_name     = aws_eks_cluster.eks_cluster.name
  subnets          = local.kubernetes_default_fargate.subnet_ids
  namespace        = local.kubernetes_default_fargate.namespace
  kubernetes_labes = local.kubernetes_default_fargate.kubernetes_labels
  create_enable    = local.use_fargate_profile

  tags = var.custom_tags

  eks_depends_on = [
    module.kube_system
  ]
}

module "scalardl_apps_fargate" {
  source = "./fargate"

  name             = "scalardl"
  cluster_name     = aws_eks_cluster.eks_cluster.name
  subnets          = local.kubernetes_scalar_apps_fargate.subnet_ids
  namespace        = local.kubernetes_scalar_apps_fargate.namespace
  kubernetes_labes = local.kubernetes_scalar_apps_fargate.kubernetes_labels
  create_enable    = local.use_fargate_profile

  tags = var.custom_tags

  eks_depends_on = [
    module.default_fargate
  ]
}

module "monitoring_fargate" {
  source = "./fargate"

  name             = "monitoring"
  cluster_name     = aws_eks_cluster.eks_cluster.name
  subnets          = local.kubernetes_monitoring_fargate.subnet_ids
  namespace        = local.kubernetes_monitoring_fargate.namespace
  kubernetes_labes = local.kubernetes_monitoring_fargate.kubernetes_labels
  create_enable    = local.use_fargate_profile

  tags = var.custom_tags

  eks_depends_on = [
    module.scalardl_apps_fargate
  ]
}
