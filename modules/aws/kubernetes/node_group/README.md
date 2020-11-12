# node_group submodule of Kubernetes AWS module

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster_name | Name of parent cluster | `string` | n/a | yes |
| iam_role_arn | ARN of the default IAM worker role to use if one is not specified in `var.node_groups` or `var.node_groups_defaults` | `string` | n/a | yes |
| kubernetes_labels | List of kubernetes labels | `map(string)` | `{}` | no |
| ng_depends_on | List of references to other resources this submodule depends on | `any` | `null` | no |
| node_group | Map of maps of `eks_node_groups` to create. See "`node_groups` and `node_groups_defaults` keys" section in README.md for more details | `any` | `{}` | no |
| tags | A map of tags to add to all resources | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| node_group | Outputs from EKS node group |

