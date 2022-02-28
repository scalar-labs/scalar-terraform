# Monitor Azure Module
The monitor Azure module deploys a Prometheus monitoring service along with an Alertmanager and Grafana. This module also deploys td-agent by default to collect logs from other instances and containers in the same network.

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
| null | ~> 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| network | The network settings of monitor resources | `map(string)` | n/a | yes |
| base | The base of monitor resources | `string` | `"default"` | no |
| cassandra | The provisioning settings of a cassandra cluster | `map(string)` | `{}` | no |
| monitor | The custom settings of monitor resources | `map(string)` | `{}` | no |
| scalardl | The provisioning settings of a scalardl cluster | `map(string)` | `{}` | no |
| slack_webhook_url | The Webhook URL of Slack for alerting | `string` | `""` | no |
| targets | The target monitoring | `tolist(string)` | `[]` | no |

## Outputs

| Name | Description |
|------|-------------|
| inventory_ini | The inventory file for Ansible. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
