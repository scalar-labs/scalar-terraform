output "node_group" {
  description = "Map of node group info"
  value       = aws_eks_node_group.default
}

output "iam_role_arn" {
  description = "IAM role arn of node group"
  value       = aws_iam_role.eks_node.*.arn
}
