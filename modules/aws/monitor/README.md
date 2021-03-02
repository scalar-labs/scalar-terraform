# Monitor AWS Module
The monitor AWS module deploys a Prometheus monitoring service along with an Alertmanager and Grafana. This module also deploys td-agent by default to collect logs from other instances and containers in the same network.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.14.7 |
| aws | ~> 2.70 |
| null | ~> 3.1 |
| template | ~> 2.2 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.70 |
| null | ~> 3.1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| network | The network settings of monitor resources | `map(string)` | n/a | yes |
| base | The base of monitor resources | `string` | `"default"` | no |
| cassandra | The provisioning settings of a cassandra cluster | `map(string)` | `{}` | no |
| custom_tags | The map of custom tags | `map(string)` | `{}` | no |
| monitor | The custom settings of monitor resources | `map(string)` | `{}` | no |
| scalardl | The provisioning settings of a scalardl cluster | `map(string)` | `{}` | no |
| slack_webhook_url | The Webhook URL of Slack for alerting | `string` | `""` | no |
| targets | The target monitoring | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| inventory_ini | The inventory file for Ansible. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
