data "aws_iam_policy_document" "cluster_autoscaler" {
  count = var.enabled ? 1 : 0

  statement {
    sid = "Autoscaling"

    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "ec2:DescribeLaunchTemplateVersions"
    ]

    resources = ["*"]

    effect = "Allow"
  }

}

resource "aws_iam_policy" "cluster_autoscaler" {
  count = var.enabled ? 1 : 0

  name        = "${var.cluster_name}-cluster-autoscaler"
  description = "Policy for cluster-autoscaler service"

  policy = data.aws_iam_policy_document.cluster_autoscaler[0].json
}

data "aws_iam_policy_document" "cluster_autoscaler_assume" {
  count = var.enabled ? 1 : 0

  statement {
    actions = ["sts:AssumeRoleWithWebIdentity"]

    principals {
      type        = "Federated"
      identifiers = [var.cluster_identity_oidc_issuer_arn]
    }

    condition {
      test     = "StringEquals"
      variable = "${replace(var.cluster_identity_oidc_issuer, "https://", "")}:sub"

      values = [
        "system:serviceaccount:kube-system:${var.k8s_service_account_name}",
      ]
    }

    effect = "Allow"
  }
}

resource "aws_iam_role" "cluster_autoscaler" {
  count = var.enabled ? 1 : 0

  name               = "${var.cluster_name}-cluster-autoscaler"
  assume_role_policy = data.aws_iam_policy_document.cluster_autoscaler_assume[0].json
}

resource "aws_iam_role_policy_attachment" "cluster_autoscaler" {
  count = var.enabled ? 1 : 0

  role       = aws_iam_role.cluster_autoscaler[0].name
  policy_arn = aws_iam_policy.cluster_autoscaler[0].arn
}
