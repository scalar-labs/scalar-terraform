resource "aws_iam_role" "fargate_pod" {
  count = var.create_enable ? 1 : 0

  name               = "${var.cluster_name}-${var.name}-fargate"
  assume_role_policy = data.aws_iam_policy_document.fargate_pod_assume_role.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "fargate_pod" {
  count = var.create_enable ? 1 : 0

  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.fargate_pod[0].name
}

resource "aws_eks_fargate_profile" "fargate_profile" {
  count = var.create_enable ? 1 : 0

  cluster_name           = var.cluster_name
  fargate_profile_name   = var.name
  pod_execution_role_arn = aws_iam_role.fargate_pod[0].arn
  subnet_ids             = var.subnets

  selector {
    namespace = var.namespace
    labels    = var.kubernetes_labes
  }

  depends_on = [var.eks_depends_on]

  tags = var.tags
}
