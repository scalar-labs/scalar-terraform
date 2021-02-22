# Cassandra Azure Module
The Cassandra Azure module deploys a Cassandra cluster tuned for a Scalar DL environment.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.14.7 |
| azurerm | =1.38.0 |
| null | ~> 3.0 |
| random | ~> 2.3 |
| tls | ~> 3.1 |

## Providers

| Name | Version |
|------|---------|
| azurerm | =1.38.0 |
| null | ~> 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| network | The network settings of Cassandra cluster | `map` | n/a | yes |
| base | The base of Cassandra cluster | `string` | `"default"` | no |
| cassandra | The custom settings of Cassandra cluster | `map` | `{}` | no |
| cassy | The custom settings of Cassy resources | `map` | `{}` | no |
| reaper | The custom settings of Reaper resources | `map` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| cassandra_host_ids | A list of host IDs for the Cassandra cluster. |
| cassandra_host_ips | A list of host IP addresess for the Cassandra cluster. |
| cassandra_provision_ids | The IDs of the provisioning step. |
| cassandra_resource_count | The number of Cassandra nodes to create. |
| cassandra_seed_ips | A list of host IP addresess for the Cassandra seeds. |
| cassandra_start_on_initial_boot | A flag to start Cassandra or not on the initial boot. |
| inventory_ini | The inventory file for Ansible. |
| network_interface_ids | A list of network interface IDs for the Cassandra cluster. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
