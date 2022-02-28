# Network Azure Module

The Network module creates a virtual network with subnets.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.14.7 |
| azurerm | =1.38.0 |
| local | ~> 2.1 |
| null | ~> 3.0 |
| random | ~> 2.3 |

## Providers

| Name | Version |
|------|---------|
| azurerm | =1.38.0 |
| local | ~> 2.1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| internal_domain | An internal DNS domain name to use for mapping IP addresses | `string` | n/a | yes |
| name | A short name to attach to resources | `string` | n/a | yes |
| private_key_path | The path to a private key file ~/.ssh/key.pem | `string` | n/a | yes |
| public_key_path | The path to a public key file ~/.ssh/key.pub | `string` | n/a | yes |
| region | The Azure region to deploy environment | `string` | n/a | yes |
| additional_public_keys_path | The path to a file that contains multiple public keys for SSH access. | `string` | `""` | no |
| base | The base of network | `string` | `"default"` | no |
| locations | The Azure availability zones to deploy environment | `tolist(string)` | `[]` | no |
| network | Custom definition for network and bastion | `map(string)` | `{}` | no |
| use_cosmosdb | Whether to use Cosmos DB. If true, a service endpoint for Cosmos DB is enabled. | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| bastion_ip | Public IP address to bastion host |
| bastion_provision_id | The provision id of bastion. |
| dns_zone_id | The virtual network DNS ID. |
| image_id | The image id to initiate. |
| internal_domain | The internal domain for setting srv record. |
| inventory_ini | The inventory file for Ansible. |
| locations | The Azure availability zones to deploy environment. |
| network_cidr | The virtual network CIDR address space. |
| network_id | The virtual network ID. |
| network_name | Short name to identify environment. |
| private_key_path | The path to the private key for SSH access. |
| public_key_path | The path to the public key for SSH access. |
| region | The Azure region to deploy environment. |
| ssh_config | The configuration file for SSH access. |
| subnet_map | The subnet map of virtual network. |
| user_name | The user name of the remote hosts. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
