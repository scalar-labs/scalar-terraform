resource "aws_eks_node_group" "default" {
  count = var.create_enable ? 1 : 0

  node_group_name = local.name

  cluster_name  = var.cluster_name
  node_role_arn = aws_iam_role.eks_node[0].arn
  subnet_ids    = local.subnet_ids

  scaling_config {
    desired_size = local.desired_capacity
    max_size     = local.max_capacity
    min_size     = local.min_capacity
  }

  ami_type       = local.ami_type
  disk_size      = local.disk_size
  instance_types = [local.instance_type]

  dynamic "remote_access" {
    for_each = local.allow_remote_access ? [{
      ec2_ssh_key               = local.ssh_key_name
      source_security_group_ids = local.source_security_group_ids
    }] : []

    content {
      ec2_ssh_key               = remote_access.value["ec2_ssh_key"]
      source_security_group_ids = remote_access.value["source_security_group_ids"]
    }
  }

  labels = var.kubernetes_labels

  tags = var.tags

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [scaling_config.0.desired_size]
  }

  depends_on = [var.ng_depends_on]
}
