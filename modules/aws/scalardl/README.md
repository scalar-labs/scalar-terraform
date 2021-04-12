# Scalar DL AWS Module
The Scalar DL module deploys a scalardl resource cluster using blue/green deployment.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.14.7 |
| aws | ~> 2.70 |
| local | ~> 2.1 |
| null | ~> 3.1 |
| template | ~> 2.2 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.70 |
| local | ~> 2.1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| network | The network settings of a scalardl cluster | `map(string)` | n/a | yes |
| base | The base of a scalardl cluster | `string` | `"default"` | no |
| custom_tags | The map of custom tags | `map(string)` | `{}` | no |
| envoy | The custom settings of an envoy cluster | `map(string)` | `{}` | no |
| scalardl | The custom settings of a scalardl cluster | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| blue_scalardl_ids | A list of host IDs for blue cluster. |
| blue_scalardl_ips | A list of host IP addresess for blue cluster. |
| envoy_dns | A list of DNS URLs to access an envoy cluster. |
| envoy_listen_port | A listen port of an envoy cluster. |
| green_scalardl_ids | A list of host IDs for green cluster. |
| green_scalardl_ips | A list of host IP addresess for green cluster. |
| inventory_ini | The inventory file for Ansible. |
| scalardl_blue_resource_count | The number of resources to create for blue cluster. |
| scalardl_green_resource_count | The number of resources to create for green cluster. |
| scalardl_replication_factor | The replication factor for the schema of scalardl. |
| scalardl_security_id | The security group ID of a scalardl cluster. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
