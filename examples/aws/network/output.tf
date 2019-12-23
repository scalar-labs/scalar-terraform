output "bastion_ip" {
  value = module.scalardl-network.bastion_ip
}

output "network_cidr" {
  value = module.scalardl-network.network_cidr
}

output "network_name" {
  value = module.scalardl-network.network_name
}

output "network_dns" {
  value = module.scalardl-network.network_dns
}

output "network_id" {
  value = module.scalardl-network.network_id
}

output "cassandra_subnet_id" {
  value = module.scalardl-network.cassandra_subnet_id
}

output "image_id" {
  value = module.scalardl-network.image_id
}

output "bastion_provision_id" {
  value = module.scalardl-network.bastion_provision_id
}

output "key_name" {
  value = module.scalardl-network.key_name
}

output "location" {
  value = module.scalardl-network.location
}

output "user_name" {
  value = module.scalardl-network.user_name
}

output "private_key_path" {
  value = module.scalardl-network.private_key_path
}


output "ssh_config" {
  value = module.scalardl-network.ssh_config
}

output "scalardl_nlb_subnet_id" {
  value = module.scalardl-network.scalardl_nlb_subnet_id
}

output "scalardl_blue_subnet_id" {
  value = module.scalardl-network.scalardl_blue_subnet_id
}

output "scalardl_green_subnet_id" {
  value = module.scalardl-network.scalardl_green_subnet_id
}
