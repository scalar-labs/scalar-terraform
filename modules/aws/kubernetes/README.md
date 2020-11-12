# Kubernetes AWS Module

## Requirements

| Name | Version |
|------|---------|
| kubernetes | ~> 1.11 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| custom_tags | The map of custom tags | `map` | `{}` | no |
| kubernetes_cluster | Custom definition kubernetes properties that include name of the cluster, kubernetes version, etc.. | `map` | `{}` | no |
| kubernetes_default_node_pool | Custom definition kubernetes default node pool that include number of node, node size, autoscaling, etc.. | `map` | `{}` | no |
| kubernetes_scalar_apps_pool | Custom definition kubernetes scalar apps node pool, same as default_node_pool | `map` | `{}` | no |
| network | Custom definition for network and bastion | `map` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| config_map_aws_auth | A kubernetes configuration to authenticate to this EKS cluster. |
| kube_config | kubectl configuration e.g: ~/.kube/config |

