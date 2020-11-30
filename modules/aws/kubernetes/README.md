# Kubernetes AWS Module

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| custom_tags | The map of custom tags | `map` | `{}` | no |
| kubernetes_cluster | Custom definition kubernetes properties that include the name of the cluster, kubernetes version, etc.. | `map` | `{}` | no |
| kubernetes_node_groups | Map of map of node groups to create | `any` | <pre>{<br>  "default_node_pool": {},<br>  "scalar_apps_pool": {}<br>}</pre> | no |
| network | Custom definition for network and bastion | `map` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| config_map_aws_auth | A kubernetes configuration to authenticate to this EKS cluster. |
| kube_config | kubectl configuration e.g: ~/.kube/config |
