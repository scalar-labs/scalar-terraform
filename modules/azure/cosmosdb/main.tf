resource "azurerm_cosmosdb_account" "db" {
  name                = "${local.network_name}-cosmosdb"
  location            = local.region
  resource_group_name = local.network_name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  enable_automatic_failover = false

  is_virtual_network_filter_enabled = var.enable_virtual_network_filter

  dynamic "virtual_network_rule" {
    for_each = toset(var.allowed_subnet_ids)
    content {
      id                                   = virtual_network_rule.value
      ignore_missing_vnet_service_endpoint = false
    }
  }

  ip_range_filter = join(",", var.allowed_cidrs)

  consistency_policy {
    consistency_level = "Strong"
  }

  geo_location {
    location          = local.region
    failover_priority = 0
  }
}
