# module "scalardl_apps_fargate" {
#   source = "./fargate"

#   cluster_name          = aws_eks_cluster.eks_cluster.name
#   fargate_profiles      = var.fargate_profiles
#   iam_policy_arn_prefix = local.policy_arn_prefix
#   subnets               = var.subnets

#   tags = var.custom_tags

#   eks_depends_on = [
#     aws_eks_cluster.eks_cluster,
#     kubernetes_config_map.aws_auth,
#   ]
# }

# module "default_fargate" {
#   source = "./fargate"

#   cluster_name          = aws_eks_cluster.eks_cluster.name
#   fargate_profiles      = var.fargate_profiles
#   iam_policy_arn_prefix = local.policy_arn_prefix
#   subnets               = var.subnets

#   tags = var.custom_tags

#   eks_depends_on = [
#     aws_eks_cluster.eks_cluster,
#     kubernetes_config_map.aws_auth,
#   ]
# }
