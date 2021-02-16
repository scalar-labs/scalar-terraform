# Pulsar AWS Module
The Pulsar module deploys a zookeeper, bookkeeper, broker resource cluster.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| network | The network settings of Pulsar cluster | `map` | n/a | yes |
| base | The base of Pulsar cluster | `string` | `"default"` | no |
| bookie | The bookie settings of Pulsar cluster | `map` | `{}` | no |
| broker | The broker settings of Pluster cluster | `map` | `{}` | no |
| custom_tags | The map of custom tags | `map(string)` | `{}` | no |
| zookeeper | The zookeeper settings of Pluster cluster | `map` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| inventory_ini | The inventory file for Ansible. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
