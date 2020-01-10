# DNS AWS Module

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| internal_root_dns | An internal DNS domain name to use for mapping IP addresses | `any` | n/a | yes |
| network_id | The network ID to create DNS zone | `any` | n/a | yes |
| network_name | The network name to attach to resource | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| dns_zone_id | DNS Zone id |
