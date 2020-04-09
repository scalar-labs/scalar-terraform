# Cassandra AWS Module
The Cassandra AWS module deploys a Cassandra cluster tuned for a Scalar DL environment.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| base | The base of Cassandra cluster | string | `"default"` | no |
| cassandra | The custom settings of Cassandra cluster | map | `<map>` | no |
| cassy | The custom settings of Cassy resources | map | `<map>` | no |
| custom_tags | The map of custom tags | map(string) | `<map>` | no |
| network | The network settings of Cassandra cluster | map | n/a | yes |
| reaper | The custom settings of Reaper resources | map | `<map>` | no |

## Outputs

| Name | Description |
|------|-------------|
| cassandra_host_ids | A list of host IDs for the Cassandra cluster. |
| cassandra_host_ips | A list of host IP addresess for the Cassandra cluster. |
| cassandra_hosts | A list of dns urls to access the Cassandra cluster. |
| cassandra_provision_ids | The IDs of the provisioning step. |
| cassandra_resource_count | The number of Cassandra nodes to create. |
| cassandra_security_ids | The security group IDs of the Cassandra cluster. |
| cassandra_seed_ips | A list of host IP addresess for the Cassandra seeds. |
| cassandra_start_on_initial_boot | A flag to start Cassandra or not on the initial boot. |
| network_interface_ids | A list of primary interface IDs for the Cassandra cluster. |

