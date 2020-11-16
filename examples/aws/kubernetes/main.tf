module "kubernetes" {
  # source = "git@github.com:scalar-labs/scalar-terraform.git//modules/aws/kubernetes?ref=v1.0.0"
  source = "../../../modules/aws/kubernetes"

  # Required Variables (Use network remote state)
  network = local.network

  use_fargate_profile          = var.use_fargate_profile
  kubernetes_cluster           = var.kubernetes_cluster
  kubernetes_default_node_pool = var.kubernetes_default_node_pool
  kubernetes_scalar_apps_pool  = var.kubernetes_scalar_apps_pool

  kubernetes_default_fargate     = var.kubernetes_default_fargate
  kubernetes_scalar_apps_fargate = var.kubernetes_scalar_apps_fargate
  kubernetes_monitoring_fargate  = var.kubernetes_monitoring_fargate

  custom_tags = var.custom_tags
}
