output "bastion_ip" {
  value = module.scalar-network.bastion_ip
}

output "network_cidr" {
  value = module.scalar-network.network_cidr
}

output "network_name" {
  value = module.scalar-network.network_name
}

output "network_dns" {
  value = module.scalar-network.network_dns
}

output "network_id" {
  value = module.scalar-network.network_id
}

output "cassandra_subnet_id" {
  value = module.scalar-network.cassandra_subnet_id
}

output "image_id" {
  value = module.scalar-network.image_id
}

output "bastion_provision_id" {
  value = module.scalar-network.bastion_provision_id
}

output "key_name" {
  value = module.scalar-network.key_name
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

output "private_subnet_id" {
  value = module.scalar-network.private_subnet_id
}

output "scalardl_blue_subnet_id" {
  value = module.scalar-network.scalardl_blue_subnet_id
}

output "scalardl_green_subnet_id" {
  value = module.scalar-network.scalardl_green_subnet_id
}

output "public_subnet_id" {
  value = module.scalar-network.public_subnet_id
}

output "internal_root_dns" {
  value = module.scalar-network.internal_root_dns
}
