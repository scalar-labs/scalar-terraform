# CA Azure Module
The CA module deploys a CA resource used to sign keys for Scalar DL.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| ca | The custom settings of CA resource | map | `<map>` | no |
| custom_tags | The map of custom tags | map(string) | `<map>` | no |
| network | The network settings of CA resource | map | n/a | yes |

