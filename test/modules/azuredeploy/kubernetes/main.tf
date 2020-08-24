module "kubernetes" {
  source = "../../../../modules/azure/kubernetes"

  # Required variables (use network remote state)
  network = local.network

  # Optional variables
  kubernetes_cluster           = var.kubernetes_cluster
  kubernetes_default_node_pool = var.kubernetes_default_node_pool
  kubernetes_scalar_apps_pool  = var.kubernetes_scalar_apps_pool
  custom_tags                  = var.custom_tags
}
