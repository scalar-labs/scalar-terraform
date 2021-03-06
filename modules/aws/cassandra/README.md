# Cassandra AWS Module
The Cassandra AWS module deploys a Cassandra cluster tuned for a Scalar DL environment.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.12 |
| aws | ~> 2.70 |
| local | ~> 2.1 |
| null | ~> 3.1 |
| tls | ~> 3.1 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.70 |
| local | ~> 2.1 |
| null | ~> 3.1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| network | The network settings of Cassandra cluster | `map(string)` | n/a | yes |
| base | The base of Cassandra cluster | `string` | `"default"` | no |
| cassandra | The custom settings of Cassandra cluster | `map(string)` | `{}` | no |
| cassy | The custom settings of Cassy resources | `map(string)` | `{}` | no |
| custom_tags | The map of custom tags | `map(string)` | `{}` | no |
| reaper | The custom settings of Reaper resources | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| cassandra_host_ids | A list of host IDs for the Cassandra cluster. |
| cassandra_host_ips | A list of host IP addresess for the Cassandra cluster. |
| cassandra_hosts | A list of dns urls to access the Cassandra cluster. |
| cassandra_resource_count | The number of Cassandra nodes to create. |
| cassandra_security_ids | The security group IDs of the Cassandra cluster. |
| cassandra_seed_ips | A list of host IP addresess for the Cassandra seeds. |
| inventory_ini | The inventory file for Ansible. |
| network_interface_ids | A list of primary interface IDs for the Cassandra cluster. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
