output "fargate_profile_id" {
  description = "EKS Fargate Profile name"
  value       = aws_eks_fargate_profile.fargate_profile.id
}

output "fargate_profile_arn" {
  description = "Amazon Resource Name (ARN) of the EKS Fargate Profile"
  value       = aws_eks_fargate_profile.fargate_profile.arn
}

output "iam_role_name" {
  description = "IAM role name for EKS Fargate pod"
  value       = aws_iam_role.fargate_pod.name
}

output "iam_role_arn" {
  description = "IAM role ARN for EKS Fargate pods"
  value       = aws_iam_role.fargate_pod.name.arn
}
