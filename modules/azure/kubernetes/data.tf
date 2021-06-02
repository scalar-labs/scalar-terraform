# Retrieve scope id for assignment
data "azurerm_subscription" "current" {
}

data "azurerm_kubernetes_service_versions" "current" {
  count = local.kubernetes_cluster.kubernetes_version != null ? 0 : 1

  location        = local.kubernetes_cluster.region
  version_prefix  = local.kubernetes_cluster.kubernetes_version_prefix
  include_preview = false
}
