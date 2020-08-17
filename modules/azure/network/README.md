# Network Azure Module

The Network module creates a virtual network with subnets.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| additional_public_keys_path | The path to a file that contains multiple public keys for SSH access. | `string` | `""` | no |
| internal_domain | An internal DNS domain name to use for mapping IP addresses | `any` | n/a | yes |
| region | The Azure region to deploy environment | `any` | n/a | yes |
| name | A short name to attach to resources | `any` | n/a | yes |
| network | Custom definition for network and bastion | `map` | `{}` | no |
| private_key_path | The path to a private key file ~/.ssh/key.pem | `any` | n/a | yes |
| public_key_path | The path to a public key file ~/.ssh/key.pub | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| bastion_ip | Public IP address to bastion host |
| bastion_provision_id | The provision id of bastion. |
| dns_zone_id | The virtual network DNS ID. |
| image_id | The image id to initiate. |
| internal_domain | The internal domain for setting srv record. |
| region | The Azure region to deploy environment. |
| network_cidr | The virtual network CIDR address space. |
| network_id | The virtual network ID. |
| network_name | Short name to identify environment. |
| private_key_path | The path to the private key for SSH access. |
| public_key_path | The path to the public key for SSH access. |
| ssh_config | The configuration file for SSH access. |
| subnet_map | The subnet map of virtual network. |
| user_name | The user name of the remote hosts. |

