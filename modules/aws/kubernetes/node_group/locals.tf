locals {
  name             = var.node_group.name
  desired_capacity = var.node_group.node_count
  ami_type         = var.node_group.ami_type
  disk_size        = var.node_group.os_disk_size_gb
  instance_type    = var.node_group.instance_type
  subnet_ids       = var.node_group.subnet_ids
  # key_name         = var.node_group.key_name
  max_capacity = var.node_group.cluster_auto_scaling_max_count
  min_capacity = var.node_group.cluster_auto_scaling_min_count

  policy_arn_prefix = "arn:${data.aws_partition.current.partition}:iam::aws:policy"
}
