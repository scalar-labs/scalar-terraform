# Network Azure Module
The Network module creates a virtual network with subnets.

## Providers

| Name | Version |
|------|---------|
| azurerm | =1.38.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| internal_root_dns | An internal DNS domain name to use for mapping IP addresses | `any` | n/a | yes |
| location | The Azure location to deploy environment | `any` | n/a | yes |
| name | A short name to attach to resources | `any` | n/a | yes |
| network | Custom definition for network and bastion | `map` | `{}` | no |
| private_key_path | The path to a private key file ~/.ssh/key.pem | `any` | n/a | yes |
| public_key_path | The path to a public key file ~/.ssh/key.pub | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| bastion_ip | Public IP address to bastion host |
| bastion_provision_id | The provision id of bastion. |
| dns_zone_id | The virtual Network DNS ID. |
| internal_root_dns | The internal root dns for setting srv record. |
| location | The AWS availability zone to deploy environment. |
| network_cidr | The Virtual Network CIDR address space. |
| network_id | The Virtual network ID. |
| network_name | Short name to identify environment. |
| private_key_path | The path to the private key for SSH access. |
| public_key_path | The path to the public key for SSH access. |
| ssh_config | The Configuration file for SSH access. |
| subnet_map | The subnet map of virtual Network. |
| user_name | The user name of the remote hosts. |
