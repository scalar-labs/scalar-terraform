output "cosmosdb_account_id" {
  value       = azurerm_cosmosdb_account.db.id
  description = "The Cosmos DB Account ID."
}

output "cosmosdb_account_endpoint" {
  value       = azurerm_cosmosdb_account.db.endpoint
  description = "The endpoint used to connect to the Cosmos DB account."
}

output "cosmosdb_account_read_endpoints" {
  value       = azurerm_cosmosdb_account.db.read_endpoints
  description = "A list of read endpoints available for the Cosmos DB account."
}

output "cosmosdb_account_write_endpoints" {
  value       = azurerm_cosmosdb_account.db.write_endpoints
  description = "A list of write endpoints available for the Cosmos DB account."
}

output "cosmosdb_account_primary_master_key" {
  value       = azurerm_cosmosdb_account.db.primary_master_key
  description = "The primary master key for the Cosmos DB account."
}

output "cosmosdb_account_secondary_master_key" {
  value       = azurerm_cosmosdb_account.db.secondary_master_key
  description = "The secondary master key for the Cosmos DB account."
}

output "cosmosdb_account_primary_readonly_master_key" {
  value       = azurerm_cosmosdb_account.db.primary_readonly_master_key
  description = "The primary read-only master key for the Cosmos DB account."
}

output "cosmosdb_account_secondary_readonly_master_key" {
  value       = azurerm_cosmosdb_account.db.secondary_readonly_master_key
  description = "The secondary read-only master key for the Cosmos DB account."
}

output "cosmosdb_account_connection_strings" {
  value       = azurerm_cosmosdb_account.db.connection_strings
  description = "A list of connection strings available for the Cosmos DB account."
}
