output "bastion_host_ids" {
  value       = module.bastion_cluster.id
  description = "A list of bastion hosts' IDs."
}

output "bastion_host_ips" {
  value       = module.bastion_cluster.public_ip
  description = "A list of bastion hosts' IP addresses."
}

output "bastion_security_group_id" {
  value       = aws_security_group.bastion.id
  description = "The security group ID of the bastion resource."
}

output "bastion_provision_id" {
  value       = module.bastion_provision.provision_id
  description = "The provision id of bastion."
}

output "key_name" {
  value       = aws_key_pair.deploy_key.key_name
  description = "The key-name of the AWS managed ssh key_pair."
}
