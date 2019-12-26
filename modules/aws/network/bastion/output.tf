output "bastion_host_ids" {
  value = module.bastion_cluster.id
}

output "bastion_host_ips" {
  value = module.bastion_cluster.public_ip
}

output "bastion_security_group_id" {
  value = aws_security_group.bastion.id
}

output "bastion_provision_id" {
  value = module.bastion_provision.provision_id
}

output "key_name" {
  value = aws_key_pair.deploy_key.key_name
}

