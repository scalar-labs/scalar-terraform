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
| cosmosdb_account_connection_strings | A list of connection strings available for the CosmosDB account. |
| cosmosdb_account_endpoint | The endpoint used to connect to the CosmosDB account. |
| cosmosdb_account_id | The CosmosDB Account ID. |
| cosmosdb_account_primary_master_key | The primary master key for the CosmosDB account. |
| cosmosdb_account_primary_readonly_master_key | The primary read-only master key for the CosmosDB account. |
| cosmosdb_account_read_endpoints | A list of read endpoints available for the CosmosDB account. |
| cosmosdb_account_secondary_master_key | The secondary master key for the CosmosDB account. |
| cosmosdb_account_secondary_readonly_master_key | The secondary read-only master key for the CosmosDB account. |
| cosmosdb_account_write_endpoints | A list of write endpoints available for the CosmosDB account. |

