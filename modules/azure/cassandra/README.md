# Cassandra Azure Module
The Cassandra Azure module deploys a Cassandra cluster tuned for a Scalar DL environment.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.14.7 |
| azurerm | =1.38.0 |
| local | ~> 2.1 |
| null | ~> 3.0 |
| random | ~> 2.3 |
| tls | ~> 3.1 |

## Providers

| Name | Version |
|------|---------|
| azurerm | =1.38.0 |
| local | ~> 2.1 |
| null | ~> 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| network | The network settings of Cassandra cluster | `map(string)` | n/a | yes |
| base | The base of Cassandra cluster | `string` | `"default"` | no |
| cassandra | The custom settings of Cassandra cluster | `map(string)` | `{}` | no |
| cassy | The custom settings of Cassy resources | `map(string)` | `{}` | no |
| reaper | The custom settings of Reaper resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| cassandra_host_ids | A list of host IDs for the Cassandra cluster. |
| cassandra_host_ips | A list of host IP addresess for the Cassandra cluster. |
| cassandra_resource_count | The number of Cassandra nodes to create. |
| cassandra_seed_ips | A list of host IP addresess for the Cassandra seeds. |
| inventory_ini | The inventory file for Ansible. |
| network_interface_ids | A list of network interface IDs for the Cassandra cluster. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
