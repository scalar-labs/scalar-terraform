# autoscaler submodule of Kubernetes AWS module

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster\_identity\_oidc\_issuer | The OIDC Identity issuer for the cluster | `string` | n/a | yes |
| cluster\_identity\_oidc\_issuer\_arn | The OIDC Identity issuer ARN for the cluster that can be used to associate IAM roles with a service account | `string` | n/a | yes |
| cluster\_name | The name of the cluster | `string` | n/a | yes |
| enabled | Variable indicating whether deployment is enabled | `bool` | `false` | no |
| helm\_chart\_name | Helm chart name to be installed | `string` | `"cluster-autoscaler-chart"` | no |
| helm\_chart\_version | Version of the Helm chart | `string` | `"1.1.1"` | no |
| helm\_release\_name | Helm release name | `string` | `"cluster-autoscaler"` | no |
| helm\_repo\_url | Helm repository | `string` | `"https://kubernetes.github.io/autoscaler"` | no |
| k8s\_service\_account\_name | The k8s cluster-autoscaler service account name | `string` | `"cluster-autoscaler"` | no |
| mod\_depends\_on | List of references to other resources this submodule depends on | `any` | `null` | no |
| region | The region | `string` | n/a | yes |
| settings | Additional settings which will be passed to the Helm chart values, see https://artifacthub.io/packages/helm/cluster-autoscaler/cluster-autoscaler-chart | `map(any)` | `{}` | no |

## Outputs

No output.
