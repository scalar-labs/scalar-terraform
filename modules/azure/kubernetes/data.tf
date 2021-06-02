data "azurerm_kubernetes_service_versions" "current" {
  count = local.kubernetes_cluster.kubernetes_version != null ? 1 : 0

  location        = local.kubernetes_cluster.region
  version_prefix  = local.kubernetes_cluster.kubernetes_version_prefix
  include_preview = false
}
