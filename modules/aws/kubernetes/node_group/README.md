# node_group submodule of Kubernetes AWS module

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster_name | Name of parent cluster | `string` | n/a | yes |
| tags | A map of tags to add to all resources | `map(string)` | n/a | yes |
| create_enable | Flag for create node group resources. | `bool` | `false` | no |
| kubernetes_labels | List of kubernetes labels | `map(string)` | `{}` | no |
| ng_depends_on | List of references to other resources this submodule depends on | `any` | `null` | no |
| node_group | A map of `eks_node_group` to create. | `map(any)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| iam_role_arn | IAM role arn of node group |
| node_group | Map of node group info |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
