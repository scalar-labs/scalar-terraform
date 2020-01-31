# CA Azure Module
The CA module deploys a CA resource used to sign keys for Scalar DL.

## Providers

| Name | Version |
|------|---------|
| azurerm | =1.38.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:-----:|
| ca | The custom settings of CA resource | `map` | `{}` | no |
| network | The network settings of CA resource | `map` | n/a | yes |

## Outputs

No output.
