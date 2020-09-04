output "cosmosdb_account_id" {
  value       = azurerm_cosmosdb_account.db.id
  description = "The ID of the Cosmos DB account."
}

output "cosmosdb_account_endpoint" {
  value       = azurerm_cosmosdb_account.db.endpoint
  description = "The endpoint of the Cosmos DB account."
}

output "cosmosdb_account_read_endpoints" {
  value = azurerm_cosmosdb_account.db.read_endpoints
}

output "cosmosdb_account_write_endpoints" {
  value = azurerm_cosmosdb_account.db.write_endpoints
}

output "cosmosdb_account_primary_master_key" {
  value = azurerm_cosmosdb_account.db.primary_master_key
}

output "cosmosdb_account_secondary_master_key" {
  value = azurerm_cosmosdb_account.db.secondary_master_key
}

output "cosmosdb_account_primary_readonly_master_key" {
  value = azurerm_cosmosdb_account.db.primary_readonly_master_key
}

output "cosmosdb_account_secondary_readonly_master_key" {
  value = azurerm_cosmosdb_account.db.secondary_readonly_master_key
}

output "cosmosdb_account_connection_strings" {
  value = azurerm_cosmosdb_account.db.connection_strings
}
