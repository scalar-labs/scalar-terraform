data "aws_iam_policy_document" "eks_node_assume_role_policy" {
  statement {
    sid = "EKSWorkerAssumeRole"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = [local.ec2_principal]
    }
  }
}

resource "aws_iam_role" "eks_node" {
  name                  = "${local.network_name}-eks-node"
  assume_role_policy    = data.aws_iam_policy_document.eks_node_assume_role_policy.json
  force_detach_policies = true

  tags = merge(
    var.custom_tags,
    {
      Terraform = "true"
      Network   = local.network_name
    }
  )
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  policy_arn = "${local.policy_arn_prefix}/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node.name
}

resource "aws_iam_role_policy_attachment" "eks_worker_cni_policy" {
  policy_arn = "${local.policy_arn_prefix}/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node.name
}

resource "aws_iam_role_policy_attachment" "eks_worker_ecr_readonly" {
  policy_arn = "${local.policy_arn_prefix}/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node.name
}
