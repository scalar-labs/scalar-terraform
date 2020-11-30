resource "aws_security_group" "eks_cluster" {
  name        = "${local.network_name}-eks-cluster"
  description = "EKS cluster security group."
  vpc_id      = local.network_id

  tags = merge(
    var.custom_tags,
    {
      "Name" = "${local.network_name}-eks-cluster"
    },
  )
}

resource "aws_security_group_rule" "eks_cluster_https_ingress" {
  description       = "Allow pods to communicate with the EKS cluster API."
  protocol          = "tcp"
  security_group_id = aws_security_group.eks_cluster.id
  cidr_blocks       = [local.network_cidr]
  from_port         = 443
  to_port           = 443
  type              = "ingress"
}

resource "aws_security_group_rule" "eks_cluster_egress_internet" {
  description       = "Allow cluster egress access to the Internet."
  protocol          = "-1"
  security_group_id = aws_security_group.eks_cluster.id
  cidr_blocks       = ["0.0.0.0/0"]
  from_port         = 0
  to_port           = 0
  type              = "egress"
}
