# Retrieve scope id for assignment
data "azurerm_subscription" "current" {
}

data "azurerm_kubernetes_service_versions" "current" {
  location        = local.kubernetes_cluster.region
  version_prefix  = local.kubernetes_cluster.kubernetes_version
  include_preview = false
}
