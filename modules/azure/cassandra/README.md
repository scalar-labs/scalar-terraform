# Cassandra Azure Module
The Cassandra Azure module deploys a Cassandra cluster tuned for a Scalar DL environment.

## Providers

| Name | Version |
|------|---------|
| azurerm | =1.38.0 |

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
| cassandra_host_ids | A list of host IDs for the cassandra cluster. |
| cassandra_host_ips | A list of host IP addresess for the cassandra cluster. |
| cassandra_provision_ids | The IDs of the provisioning step. |
| cassandra_resource_count | The number of cassandra nodes to create. |
| cassandra_seed_ips | A list of host IP addresess for the cassandra seeds. |
| cassandra_start_on_initial_boot | A flag to start cassandra or not on the initial boot. |
| network_interface_ids | A list of network interface ID for the cassandra cluster. |
