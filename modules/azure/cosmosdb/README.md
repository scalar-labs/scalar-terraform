# Cosmos DB Azure Module
The Cosmos DB Azure module deploys a Cosmos DB account.

## Requirements

| Name | Version |
|------|---------|
| azurerm | =1.38.0 |

## Providers

| Name | Version |
|------|---------|
| azurerm | =1.38.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| kubernetes | The kubernetes settings of Cosmos DB | `map` | n/a | yes |
| network | The network settings of Cosmos DB | `map` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| cosmosdb_account_connection_strings | n/a |
| cosmosdb_account_endpoint | The endpoint of the Cosmos DB account. |
| cosmosdb_account_id | The ID of the Cosmos DB account. |
| cosmosdb_account_primary_master_key | n/a |
| cosmosdb_account_primary_readonly_master_key | n/a |
| cosmosdb_account_read_endpoints | n/a |
| cosmosdb_account_secondary_master_key | n/a |
| cosmosdb_account_secondary_readonly_master_key | n/a |
| cosmosdb_account_write_endpoints | n/a |
