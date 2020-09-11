# Pulsar AWS Module
The Pulsar module deploys a zookeeper, bookkeeper, broker resource cluster.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| base | The base of Pulsar cluster | `string` | `"default"` | no |
| bookie | The bookie settings of Pulsar cluster | `map` | `{}` | no |
| broker | The broker settings of Pluster cluster | `map` | `{}` | no |
| custom_tags | The map of custom tags | `map(string)` | `{}` | no |
| network | The network settings of Pulsar cluster | `map` | n/a | yes |
| zookeeper | The zookeeper settings of Pluster cluster | `map` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| inventory_ini | n/a |

