output "bastion_host_ids" {
  value = module.bastion_cluster.vm_ids
}

output "bastion_host_ips" {
  value = module.bastion_cluster.public_ip_dns_name
}

output "bastion_security_group_id" {
  value = module.bastion_cluster.network_security_group_id
}

output "bastion_provision_id" {
  value = module.bastion_provision.provision_id
}

