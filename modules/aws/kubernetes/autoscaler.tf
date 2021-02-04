provider "helm" {
  kubernetes {
    config_path = local.kubeconfig_name
  }
}

module "cluster_autoscaler" {
  source = "./autoscaler"

  enabled                          = local.kubernetes_cluster.cluster_auto_scaling
  cluster_name                     = aws_eks_cluster.eks_cluster.id
  cluster_identity_oidc_issuer     = join("", aws_eks_cluster.eks_cluster.*.identity.0.oidc.0.issuer)
  cluster_identity_oidc_issuer_arn = join("", aws_iam_openid_connect_provider.cluster_autoscaler.*.arn)
  region                           = local.region
  mod_depends_on                   = [local_file.kubeconfig]
}

resource "aws_iam_openid_connect_provider" "cluster_autoscaler" {
  count = local.kubernetes_cluster.cluster_auto_scaling ? 1 : 0

  url = join("", aws_eks_cluster.eks_cluster.*.identity.0.oidc.0.issuer)

  client_id_list = ["sts.amazonaws.com"]

  # it's thumbprint won't change for many years
  # https://github.com/terraform-providers/terraform-provider-aws/issues/10104
  thumbprint_list = ["9e99a48a9960b14926bb7f3b02e22da2b0ab7280"]
}
