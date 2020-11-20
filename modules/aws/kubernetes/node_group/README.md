# node_group submodule of Kubernetes AWS module

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster_name | Name of parent cluster | `string` | n/a | yes |
| create_enable | Flag for create node group resources. | `bool` | `false` | no |
| kubernetes_labels | List of kubernetes labels | `map(string)` | `{}` | no |
| ng_depends_on | List of references to other resources this submodule depends on | `any` | `null` | no |
| node_group | Map of maps of `eks_node_groups` to create. See "`node_groups` and `node_groups_defaults` keys" section in README.md for more details | `any` | `{}` | no |
| tags | A map of tags to add to all resources | `map(string)` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| iam_role_arn | IAM role arn of node group |
| node_group | Map of node group info |
