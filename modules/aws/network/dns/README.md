# DNS AWS Module

## Providers

| Name | Version |
|------|---------|
| aws | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| custom_tags | The map of custom tags | `map` | `{}` | no |
| internal_domain | An internal DNS domain name to use for mapping IP addresses | `any` | n/a | yes |
| network_id | The network ID to create DNS zone | `any` | n/a | yes |
| network_name | The network name to attach to resource | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| dns_zone_id | DNS Zone id |

