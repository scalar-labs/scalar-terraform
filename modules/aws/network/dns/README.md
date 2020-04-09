# DNS AWS Module

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| custom_tags | The map of custom tags | map | `<map>` | no |
| internal_domain | An internal DNS domain name to use for mapping IP addresses | string | n/a | yes |
| network_id | The network ID to create DNS zone | string | n/a | yes |
| network_name | The network name to attach to resource | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| dns_zone_id | DNS Zone id |

