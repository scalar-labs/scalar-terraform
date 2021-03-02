# Kubernetes AWS Module

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Requirements

| Name | Version |
|------|---------|
| terraform | ~> 0.14.7 |
| aws | ~> 2.70 |
| helm | ~> 2.0 |
| kubernetes | ~> 1.13 |
| local | ~> 2.1 |
| null | ~> 3.1 |

## Providers

| Name | Version |
|------|---------|
| aws | ~> 2.70 |
| kubernetes | ~> 1.13 |
| local | ~> 2.1 |
| null | ~> 3.1 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| custom_tags | The map of custom tags | `map(string)` | `{}` | no |
| kubernetes_cluster | Custom definition kubernetes properties that include the name of the cluster, kubernetes version, etc.. | `map(string)` | `{}` | no |
| kubernetes_node_groups | Map of map of node groups to create | `any` | <pre>{<br>  "default_node_pool": {},<br>  "scalar_apps_pool": {}<br>}</pre> | no |
| network | Custom definition for network and bastion | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| config_map_aws_auth | A kubernetes configuration to authenticate to this EKS cluster. |
| kube_config | kubectl configuration e.g: ~/.kube/config |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
