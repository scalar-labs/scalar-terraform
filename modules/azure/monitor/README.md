# Monitor Azure Module
The monitor Azure module deploys a Prometheus monitoring service along with an Alertmanager and Grafana. This module also deploys td-agent by default to collect logs from other instances and containers in the same network.

## Providers

| Name | Version |
|------|---------|
| azurerm | =1.38.0 |

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| network | The network settings of monitor resources | `map` | n/a | yes |
| base | The base of monitor resources | `string` | `"default"` | no |
| cassandra | The provisioning settings of a cassandra cluster | `map` | `{}` | no |
| monitor | The custom settings of monitor resources | `map` | `{}` | no |
| scalardl | The provisioning settings of a scalardl cluster | `map` | `{}` | no |
| slack_webhook_url | The Webhook URL of Slack for alerting | `string` | `""` | no |
| targets | The target monitoring | `list(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| inventory_ini | The inventory file for Ansible. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
