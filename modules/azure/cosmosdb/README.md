# Cosmos DB Azure Module
The Cosmos DB Azure module deploys a Cosmos DB account.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.14.7 |
| azurerm | ~> 2.70 |

## Providers

| Name | Version |
|------|---------|
| azurerm | ~> 2.70 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| network | The network settings of Cosmos DB | `map(string)` | n/a | yes |
| allowed_cidrs | IP addresses or IP address ranges in CIDR to allow access to Cosmos DB | `list(string)` | `[]` | no |
| allowed_subnet_ids | The subnet IDs to allow access to Cosmos DB | `list(string)` | `[]` | no |
| is_virtual_network_filter_enabled | A flag to enable virtual network filtering for Cosmos DB | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| cosmosdb_account_connection_strings | A list of connection strings available for the Cosmos DB account. |
| cosmosdb_account_endpoint | The endpoint used to connect to the Cosmos DB account. |
| cosmosdb_account_id | The Cosmos DB Account ID. |
| cosmosdb_account_primary_master_key | The primary master key for the Cosmos DB account. |
| cosmosdb_account_primary_readonly_master_key | The primary read-only master key for the Cosmos DB account. |
| cosmosdb_account_read_endpoints | A list of read endpoints available for the Cosmos DB account. |
| cosmosdb_account_secondary_master_key | The secondary master key for the Cosmos DB account. |
| cosmosdb_account_secondary_readonly_master_key | The secondary read-only master key for the Cosmos DB account. |
| cosmosdb_account_write_endpoints | A list of write endpoints available for the Cosmos DB account. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
