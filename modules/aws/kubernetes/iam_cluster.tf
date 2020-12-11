resource "aws_iam_role" "eks_cluster" {
  name                  = "${local.network_name}-eks-cluster"
  assume_role_policy    = data.aws_iam_policy_document.cluster_assume_role_policy.json
  force_detach_policies = true

  tags = merge(
    var.custom_tags,
    {
      Terraform = "true"
      Network   = local.network_name
    }
  )
}

data "aws_iam_policy_document" "cluster_assume_role_policy" {
  statement {
    sid = "EKSClusterAssumeRole"

    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  policy_arn = "${local.policy_arn_prefix}/AmazonEKSClusterPolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "eks_service_policy" {
  policy_arn = "${local.policy_arn_prefix}/AmazonEKSServicePolicy"
  role       = aws_iam_role.eks_cluster.name
}

resource "aws_iam_role_policy_attachment" "eks_svpc_resource_controller_policy" {
  policy_arn = "${local.policy_arn_prefix}/AmazonEKSVPCResourceController"
  role       = aws_iam_role.eks_cluster.name
}

data "aws_iam_policy_document" "eks_cluster_logging_policy" {
  count = length(local.kubernetes_cluster.cluster_enabled_log_types) > 0 ? 1 : 0

  statement {
    effect = "Allow"
    actions = [
      "logs:CreateLogGroup",
      "logs:DescribeLogGroups",
      "logs:DeleteLogGroup",
      "logs:ListTagsLogGroup",
      "logs:PutRetentionPolicy",
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "eks_cluster_logging_policy" {
  count = length(local.kubernetes_cluster.cluster_enabled_log_types) > 0 ? 1 : 0

  name_prefix = "${local.network_name}-eks-loggging"
  description = "Permissions for EKS to put logs to cloudwatch logs"
  policy      = data.aws_iam_policy_document.eks_cluster_logging_policy[0].json
}

resource "aws_iam_role_policy_attachment" "eks_cluster_logging_policy" {
  count = length(local.kubernetes_cluster.cluster_enabled_log_types) > 0 ? 1 : 0

  policy_arn = aws_iam_policy.eks_cluster_logging_policy[0].arn
  role       = aws_iam_role.eks_cluster.name
}

data "aws_iam_policy_document" "eks_elb_sl_role_creation" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:DescribeAccountAttributes",
      "ec2:DescribeInternetGateways"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "eks_elb_sl_role_creation" {
  name_prefix = "${local.network_name}-eks-elb-sl"
  description = "Permissions for EKS to create AWSServiceRoleForElasticLoadBalancing service-linked role"
  policy      = data.aws_iam_policy_document.eks_elb_sl_role_creation.json
}

resource "aws_iam_role_policy_attachment" "cluster_elb_sl_role_creation" {
  policy_arn = aws_iam_policy.eks_elb_sl_role_creation.arn
  role       = aws_iam_role.eks_cluster.name
}
