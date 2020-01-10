# Cassandra AWS Module
The Cassandra AWS module deploys a Cassandra cluster tuned for a Scalar DL environment.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| base | The base of cassandra cluster | `string` | `"default"` | no |
| cassandra | The custom settings of cassandra cluster | `map` | `{}` | no |
| cassy | The custom settings of cassy resources | `map` | `{}` | no |
| network | The network settings of cassandra cluster | `map` | n/a | yes |
| reaper | The custom settings of reaper resources | `map` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| cassandra_host_ids | A list of host ids for the cassandra cluster. |
| cassandra_host_ips | A list of host IP addresess for the cassandra cluster. |
| cassandra_hosts | A list of dns urls to access the cassandra cluster. |
| cassandra_provision_ids | The ID of the provisioning step. |
| cassandra_resource_count | The number of cassandra seed resources to create. |
| cassandra_security_ids | The security group ID of the cassandra cluster. |
| cassandra_seed_ips | A list of host IP addresess for the cassandra seeds. |
| cassandra_start_on_initial_boot | A flag to start cassandra or not on the initial boot. |
| network_interface_ids | A list of primary interface id for the cassandra cluster. |
