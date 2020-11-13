data "aws_iam_policy_document" "eks_node_assume_role_policy" {
  statement {
    sid = "EKSWorkerAssumeRole"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["ec2.${data.aws_partition.current.dns_suffix}"]
    }
  }
}

resource "aws_iam_role" "eks_node" {
  count = var.create_enable ? 1 : 0

  name                  = "${var.cluster_name}-${local.name}-eks-node"
  assume_role_policy    = data.aws_iam_policy_document.eks_node_assume_role_policy.json
  force_detach_policies = true

  tags = merge(
    var.tags,
    {
      Terraform = "true"
      Network   = "${var.cluster_name}-${local.name}-eks-node"
    }
  )
}

resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  count = var.create_enable ? 1 : 0

  policy_arn = "${local.policy_arn_prefix}/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.eks_node[0].name
}

resource "aws_iam_role_policy_attachment" "eks_worker_cni_policy" {
  count = var.create_enable ? 1 : 0

  policy_arn = "${local.policy_arn_prefix}/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.eks_node[0].name
}

resource "aws_iam_role_policy_attachment" "eks_worker_ecr_readonly" {
  count = var.create_enable ? 1 : 0

  policy_arn = "${local.policy_arn_prefix}/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.eks_node[0].name
}
