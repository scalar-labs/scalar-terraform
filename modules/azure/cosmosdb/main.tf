resource "azurerm_cosmosdb_account" "db" {
  name                = "${local.network_name}-cosmosdb"
  location            = local.region
  resource_group_name = local.network_name
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB"

  enable_automatic_failover = false

  is_virtual_network_filter_enabled = true

  virtual_network_rule {
    id = local.node_pool_subnet_id
  }

  consistency_policy {
    consistency_level = "Strong"
  }

  geo_location {
    location          = local.region
    failover_priority = 0
  }
}
