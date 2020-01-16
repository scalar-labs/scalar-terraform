output "bastion_ip" {
  value = module.scalar-network.bastion_ip
}

output "network_cidr" {
  value = module.scalar-network.network_cidr
}

output "network_name" {
  value = module.scalar-network.network_name
}

output "dns_zone_id" {
  value = module.scalar-network.dns_zone_id
}

output "network_id" {
  value = module.scalar-network.network_id
}

output "subnet_map" {
  value = module.scalar-network.subnet_map
}

output "bastion_provision_id" {
  value = module.scalar-network.bastion_provision_id
}

output "public_key_path" {
  value = module.scalar-network.public_key_path
}

output "location" {
  value = module.scalar-network.location
}

output "user_name" {
  value = module.scalar-network.user_name
}

output "private_key_path" {
  value = module.scalar-network.private_key_path
}

output "ssh_config" {
  value = module.scalar-network.ssh_config
}

output "internal_root_dns" {
  value = module.scalar-network.internal_root_dns
}
