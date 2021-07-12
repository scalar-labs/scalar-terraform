data "aws_caller_identity" "current" {}

data "aws_partition" "current" {}

data "http" "wait_for_cluster" {
  count = local.kubernetes_cluster.manage_aws_auth ? 1 : 0

  url            = format("%s/healthz", aws_eks_cluster.eks_cluster.endpoint)
  ca_certificate = base64decode(aws_eks_cluster.eks_cluster.certificate_authority[0].data)
  timeout        = 300

  depends_on = [
    aws_eks_cluster.eks_cluster,
    aws_security_group.eks_cluster
  ]
}
