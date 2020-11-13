resource "aws_iam_role" "fargate_pod" {
  name               = "${var.cluster_name}-${var.name}-fargate"
  assume_role_policy = data.aws_iam_policy_document.fargate_pod_assume_role.json

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "fargate_pod" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSFargatePodExecutionRolePolicy"
  role       = aws_iam_role.fargate_pod.name
}

resource "aws_eks_fargate_profile" "fargate_profile" {
  cluster_name           = var.cluster_name
  fargate_profile_name   = "${var.cluster_name}-${var.name}-fargate"
  pod_execution_role_arn = aws_iam_role.fargate_pod.arn
  subnet_ids             = var.subnets

  selector {
    namespace = var.namespace
    labels    = var.kubernetes_labes
  }

  depends_on = [var.eks_depends_on]

  tags = var.tags
}
