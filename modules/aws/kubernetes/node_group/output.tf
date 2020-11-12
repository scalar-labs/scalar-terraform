output "node_group" {
  description = "Outputs from EKS node group"
  value       = aws_eks_node_group.default
}
