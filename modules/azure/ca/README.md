# CA Azure Module
The CA module deploys a CA resource used to sign keys for Scalar DL.

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
| network | The network settings of CA resource | `map(string)` | n/a | yes |
| ca | The custom settings of CA resource | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| inventory_ini | The inventory file for Ansible. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
