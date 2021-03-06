# Cluster Module of Scalar DL
The Cluster module deploys a Scalar DL cluster on Azure.


<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| bastion_ip | The IP to bastion host used for provisioning | `string` | n/a | yes |
| container_env_file | The environment variables file for the docker container | `string` | n/a | yes |
| image_id | The image id to initiate | `string` | n/a | yes |
| internal_domain | Internal domain | `string` | n/a | yes |
| locations | The Azure availability zones to deploy environment | `list(string)` | n/a | yes |
| network_dns | The ID for the internal DNS zone | `string` | n/a | yes |
| network_name | The name of the network resources: should be generated by provider/universal/name-generator | `string` | n/a | yes |
| private_key_path | The path to the private key for SSH access | `string` | n/a | yes |
| public_key_path | The path to the public key for SSH access | `string` | n/a | yes |
| region | The Azure region to deploy environment | `string` | n/a | yes |
| resource_cluster_name | The name to assign the resource cluster | `string` | n/a | yes |
| resource_count | The number of resources to create | `number` | n/a | yes |
| resource_root_volume_size | The size of resource root volume size | `number` | n/a | yes |
| resource_type | The resource type of the bastion instance | `string` | n/a | yes |
| scalardl_image_name | The docker image for Scalar DL | `string` | n/a | yes |
| scalardl_image_tag | The docker image tag for Scalar DL | `string` | n/a | yes |
| subnet_id | The subnet ID to launch scalardl hosts | `string` | n/a | yes |
| user_name | The user name of the remote hosts | `string` | n/a | yes |
| availability_set_id | The ID of the Availability Set | `string` | `""` | no |
| cassandra_replication_factor | The replication factor for the Cassandra schema | `number` | `3` | no |
| enable_accelerated_networking | A flag to enable accelerated networking on network interface | `bool` | `false` | no |
| enable_tdagent | A flag to install td-agent that forwards logs to the monitor host | `bool` | `true` | no |

## Outputs

| Name | Description |
|------|-------------|
| network_interface_ids | A list of network interface IDs associated with the VM. |
| network_interface_private_ip | A list of private IP addresses assigned to scalardl cluster instances. |
| vm_ids | A list of VM IDs of a scalardl cluster. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
