data "aws_iam_policy_document" "fargate_pod_assume_role" {
  count = var.create_fargate ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["eks-fargate-pods.amazonaws.com"]
    }
  }
}
