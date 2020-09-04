resource "azurerm_cosmosdb_account" "db" {
  name                = "${local.network_name}-cosmos-db"
  location            = local.region
  resource_group_name = local.network_name
  offer_type          = "Standard"

  enable_automatic_failover = true

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

# resource "azurerm_cosmosdb_sql_container" "example" {
#   name                = "example-container"
#   resource_group_name = azurerm_cosmosdb_account.example.resource_group_name
#   account_name        = azurerm_cosmosdb_account.example.name
#   database_name       = azurerm_cosmosdb_sql_database.example.name
#   partition_key_path  = "/definition/id"
#   throughput          = 400

#   unique_key {
#     paths = ["/definition/idlong", "/definition/idshort"]
#   }
# }
