# AMI-selector AWS Module
The ami-selector module will find a valid AMI id for a given region.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| most_recent |  | string | `"true"` | no |
| name |  | string | `"CentOS Linux 7 x86_64*"` | no |
| owners |  | list | `<list>` | no |

## Outputs

| Name | Description |
|------|-------------|
| image_id | An AMI id for the given region. |

