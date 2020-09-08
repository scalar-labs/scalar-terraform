output "bastion_ip" {
  value = module.network.bastion_ip
}

output "network_cidr" {
  value = module.network.network_cidr
}

output "network_name" {
  value = module.network.network_name
}

output "network_dns" {
  value = module.network.network_dns
}

output "network_id" {
  value = module.network.network_id
}

output "subnet_map" {
  value = module.network.subnet_map
}

output "image_id" {
  value = module.network.image_id
}

output "bastion_provision_id" {
  value = module.network.bastion_provision_id
}

output "key_name" {
  value = module.network.key_name
}

output "region" {
  value = var.region
}

output "locations" {
  value = module.network.locations
}

output "user_name" {
  value = module.network.user_name
}

output "private_key_path" {
  value = module.network.private_key_path
}

output "ssh_config" {
  value = module.network.ssh_config
}

output "internal_domain" {
  value = module.network.internal_domain
}

output "custom_tags" {
  value = var.custom_tags
}
