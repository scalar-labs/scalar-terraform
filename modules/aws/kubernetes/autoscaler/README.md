# autoscaler submodule of Kubernetes AWS module

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| cluster_identity_oidc_issuer | The OIDC Identity issuer for the cluster | `string` | n/a | yes |
| cluster_identity_oidc_issuer_arn | The OIDC Identity issuer ARN for the cluster that can be used to associate IAM roles with a service account | `string` | n/a | yes |
| cluster_name | The name of the cluster | `string` | n/a | yes |
| region | The region | `string` | n/a | yes |
| enabled | Variable indicating whether deployment is enabled | `bool` | `false` | no |
| helm_chart_name | Helm chart name to be installed | `string` | `"cluster-autoscaler-chart"` | no |
| helm_chart_version | Version of the Helm chart | `string` | `"1.1.1"` | no |
| helm_release_name | Helm release name | `string` | `"cluster-autoscaler"` | no |
| helm_repo_url | Helm repository | `string` | `"https://kubernetes.github.io/autoscaler"` | no |
| k8s_service_account_name | The k8s cluster-autoscaler service account name | `string` | `"cluster-autoscaler"` | no |
| mod_depends_on | List of references to other resources this submodule depends on | `any` | `null` | no |
| settings | Additional settings which will be passed to the Helm chart values, see https://artifacthub.io/packages/helm/cluster-autoscaler/cluster-autoscaler-chart | `map(any)` | `{}` | no |

## Outputs

No output.

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
