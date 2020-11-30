data "aws_iam_role" "bastion" {
  name = "${local.network_name}-bastion"
}

resource "aws_iam_policy" "bastion_eks" {
  name   = "${local.network_name}-bastion-eks-policy"
  policy = data.aws_iam_policy_document.bastion_eks.json
}

resource "aws_iam_role_policy_attachment" "bastion_eks" {
  role       = data.aws_iam_role.bastion.name
  policy_arn = aws_iam_policy.bastion_eks.arn
}

data "aws_iam_policy_document" "bastion_eks" {
  statement {
    effect = "Allow"

    actions   = ["eks:*"]
    resources = [aws_eks_cluster.eks_cluster.arn]
  }

  statement {
    effect = "Allow"

    actions = [
      "iam:PassRole",
    ]

    condition {
      test     = "StringEqualsIfExists"
      variable = "iam:PassedToService"

      values = [
        "eks.amazonaws.com",
      ]
    }

    resources = ["*"]
  }
}
