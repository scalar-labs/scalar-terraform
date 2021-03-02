# DNS AWS Module

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| internal_domain | An internal DNS domain name to use for mapping IP addresses | `string` | n/a | yes |
| network_id | The network ID to create DNS zone | `string` | n/a | yes |
| network_name | The network name to attach to resource | `string` | n/a | yes |
| custom_tags | The map of custom tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| dns_zone_id | DNS Zone id |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
