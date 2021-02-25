# CA AWS Module
The CA module deploys a CA resource used to sign keys for Scalar DL.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.14.7 |
| aws | ~> 2.70 |
| null | ~> 3.1 |
| template | ~> 2.2 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.70 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| network | The network settings of CA resource | `map(string)` | n/a | yes |
| ca | The custom settings of CA resource | `map(string)` | `{}` | no |
| custom_tags | The map of custom tags | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| inventory_ini | The inventory file for Ansible. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
