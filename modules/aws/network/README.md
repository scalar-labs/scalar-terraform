# Network AWS Module

The Network module creates a virtual network with subnets.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.14.7 |
| aws | ~> 2.70 |
| null | ~> 3.1 |
| random | ~> 3.1 |
| template | ~> 2.2 |

## Providers

| Name | Version |
| aws | ~> 2.70 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| internal_domain | An internal DNS domain name to use for mapping IP addresses | `string` | n/a | yes |
| locations | The AWS availability zones to deploy environment `ap-northeast-1a` | `list(string)` | n/a | yes |
| name | A short name to attach to resources | `any` | n/a | yes |
| private_key_path | The path to a private key file ~/.ssh/key.pem | `string` | n/a | yes |
| public_key_path | The path to a public key file ~/.ssh/key.pub | `string` | n/a | yes |
| additional_public_keys_path | The path to a file that contains multiple public keys for SSH access. | `string` | `""` | no |
| base | The base of network | `string` | `"default"` | no |
| custom_tags | The map of custom tags | `map(string)` | `{}` | no |
| network | Custom definition for network and bastion | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| bastion_ip | Public IP address to bastion host |
| bastion_provision_id | The provision id of bastion. |
| custom_tags | The internal domain for setting srv record |
| image_id | The image id to initiate. |
| internal_domain | The internal domain for setting srv record |
| inventory_ini | The inventory file for Ansible. |
| key_name | The key-name of the AWS managed ssh key_pair. |
| locations | The AWS availability zones to deploy environment. |
| network_cidr | Network CIDR address space. |
| network_dns | The VPC network DNS ID. |
| network_id | The VPC network ID. |
| network_name | Short name to identify environment. |
| private_key_path | The path to the private key for SSH access. |
| ssh_config | The Configuration file for SSH access. |
| subnet_map | The subnet map of VPC network. |
| user_name | The user name of the remote hosts. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
