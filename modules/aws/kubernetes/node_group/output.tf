output "node_group" {
  description = "Outputs from EKS node group"
  value       = aws_eks_node_group.default
}

output "iam_role_arn" {
  value = aws_iam_role.eks_node.*.arn
}
