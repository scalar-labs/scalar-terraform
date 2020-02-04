# Monitor Azure Module
The monitor Azure module deploys a Prometheus monitoring service along with an Alertmanager and Grafana. This module also deploys td-agent by default to collect logs from other instances and containers in the same network.

## Providers

| Name | Version |
|------|---------|
| azurerm | =1.38.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| base | The base of monitor resources | `string` | `"default"` | no |
| cassandra | The provisioning settings of a cassandra cluster | `map` | n/a | yes |
| monitor | The custom settings of monitor resources | `map` | `{}` | no |
| network | The network settings of monitor resources | `map` | n/a | yes |
| scalardl | The provisioning settings of a scalardl cluster | `map` | n/a | yes |
| slack_webhook_url | The Webhook URL of Slack for alerting | `string` | `""` | no |

## Outputs

No output.
