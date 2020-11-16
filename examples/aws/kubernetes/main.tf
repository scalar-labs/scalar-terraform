module "kubernetes" {
  # source = "git@github.com:scalar-labs/scalar-terraform.git//modules/aws/kubernetes?ref=v1.0.0"
  source = "../../../modules/aws/kubernetes"

  # Required Variables (Use network remote state)
  network = local.network

  use_fargate_profile         = var.use_fargate_profile
  kubernetes_cluster          = var.kubernetes_cluster
  kubernetes_node_groups      = var.kubernetes_node_groups
  kubernetes_fargate_profiles = var.kubernetes_fargate_profiles

  custom_tags = var.custom_tags
}
