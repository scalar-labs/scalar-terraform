resource "aws_eks_node_group" "default" {
  node_group_name = local.name

  cluster_name  = var.cluster_name
  node_role_arn = var.iam_role_arn
  subnet_ids    = local.subnet_ids

  scaling_config {
    desired_size = local.desired_capacity
    max_size     = local.max_capacity
    min_size     = local.min_capacity
  }

  ami_type       = local.ami_type
  disk_size      = local.disk_size
  instance_types = [local.instance_type]

  labels = var.kubernetes_labels

  tags = var.tags

  lifecycle {
    create_before_destroy = true
    ignore_changes        = [scaling_config.0.desired_size]
  }

  depends_on = [var.ng_depends_on]
}
