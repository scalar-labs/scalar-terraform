# Scalar DL AWS Module
The Scalar DL module deploys a scalar dl resource cluster using blue/green deployment.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| base | The base of scalardl cluster | `string` | `"default"` | no |
| cassandra | The provisioning settings of cassandra cluster | `map` | n/a | yes |
| envoy | The custom settings of envoy cluster | `map` | `{}` | no |
| network | The network settings of scalardl cluster | `map` | n/a | yes |
| scalardl | The custom settings of scalardl cluster | `map` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| blue_scalardl_ids | The ID of the provisioning step for blue scalardl. |
| blue_scalardl_ips | A list of host IP addresess for the blue scalardl. |
| green_scalardl_ids | The ID of the provisioning step for green scalardl. |
| green_scalardl_ips | A list of host IP addresess for the green scalardl. |
| scalardl_blue_resource_count | The number of resources to create blue scalardl. |
| scalardl_green_resource_count | The number of resources to create green scalardl. |
| scalardl_lb_dns | A list of dns urls to access the scalardl cluster. |
| scalardl_replication_factor | The replication factor for schema of scalardl. |
| scalardl_security_id | The security group ID of the scalardl cluster. |
