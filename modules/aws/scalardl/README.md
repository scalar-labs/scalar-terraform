# Scalar DL AWS Module
The Scalar DL module deploys a scalardl resource cluster using blue/green deployment.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| base | The base of a scalardl cluster | `string` | `"default"` | no |
| cassandra | The provisioning settings of a cassandra cluster | `map` | n/a | yes |
| envoy | The custom settings of an envoy cluster | `map` | `{}` | no |
| network | The network settings of a scalardl cluster | `map` | n/a | yes |
| scalardl | The custom settings of a scalardl cluster | `map` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| blue_scalardl_ids | A list of host IDs for blue cluster. |
| blue_scalardl_ips | A list of host IP addresess for blue cluster. |
| envoy_dns | A list of DNS URLs to access an envoy cluster. |
| envoy_listen_port | A listen port of an envoy cluster. |
| green_scalardl_ids | A list of host IDs for green cluster. |
| green_scalardl_ips | A list of host IP addresess for green cluster. |
| scalardl_blue_resource_count | The number of resources to create for blue cluster. |
| scalardl_green_resource_count | The number of resources to create for green cluster. |
| scalardl_lb_dns | A list of dns URLs to access a scalardl cluster. |
| scalardl_lb_listen_port | A listen port of a scalardl cluster. |
| scalardl_replication_factor | The replication factor for the schema of scalardl. |
| scalardl_security_id | The security group ID of a scalardl cluster. |
