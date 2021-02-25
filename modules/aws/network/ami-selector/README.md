# AMI-selector AWS Module
The ami-selector module will find a valid AMI id for a given region.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| most_recent | n/a | `bool` | `true` | no |
| name | n/a | `string` | `"CentOS Linux 7 x86_64 - 20200407*"` | no |
| owners | n/a | `list(string)` | <pre>[<br>  "825543958249"<br>]</pre> | no |

## Outputs

| Name | Description |
|------|-------------|
| image_id | An AMI id for the given region. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
