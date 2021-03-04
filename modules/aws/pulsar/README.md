# Pulsar AWS Module
The Pulsar module deploys a zookeeper, bookkeeper, broker resource cluster.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.14.7 |
| aws | ~> 2.70 |
| local | ~> 2.1 |
| template | ~> 2.2 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.70 |
| local | ~> 2.1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| network | The network settings of Pulsar cluster | `map(string)` | n/a | yes |
| base | The base of Pulsar cluster | `string` | `"default"` | no |
| bookie | The bookie settings of Pulsar cluster | `map(string)` | `{}` | no |
| broker | The broker settings of Pluster cluster | `map(string)` | `{}` | no |
| custom_tags | The map of custom tags | `map(string)` | `{}` | no |
| zookeeper | The zookeeper settings of Pluster cluster | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| inventory_ini | The inventory file for Ansible. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
