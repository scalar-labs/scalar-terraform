output "network_id" {
  value       = azurerm_virtual_network.vnet.id
  description = "The Virtual network ID."
}

output "network_name" {
  value       = module.name_generator.name
  description = "Short name to identify environment."
}

output "network_cidr" {
  value       = azurerm_virtual_network.vnet.address_space[0]
  description = "The Virtual Network CIDR address space."
}

output "subnet_map" {
  value       = local.subnet
  description = "The subnet map of virtual Network."
}

output "image_id" {
  value       = local.network.image_id
  description = "The image id to initiate."
}

output "dns_zone_id" {
  value = basename(azurerm_private_dns_zone.dns.id)
  description = "The virtual Network DNS ID."
}

output "bastion_provision_id" {
  value       = module.bastion.bastion_provision_id
  description = "The provision id of bastion."
}

output "public_key_path" {
  value       = abspath(pathexpand(var.public_key_path))
  description = "The path to the public key for SSH access."
}

output "bastion_ip" {
  value       = module.bastion.bastion_host_ips[0]
  description = "Public IP address to bastion host"
}

output "location" {
  value       = var.location
  description = "The AWS availability zone to deploy environment."
}

output "user_name" {
  value       = local.network.user_name
  description = "The user name of the remote hosts."
}

output "private_key_path" {
  value       = abspath(pathexpand(var.private_key_path))
  description = "The path to the private key for SSH access."
}

output "internal_root_dns" {
  value       = var.internal_root_dns
  description = "The internal root dns for setting srv record."
}

output "ssh_config" {
  value = <<EOF
Host *
User ${local.network.user_name}
UserKnownHostsFile /dev/null
StrictHostKeyChecking no

Host bastion
HostName ${module.bastion.bastion_host_ips[0]}
LocalForward 8000 monitor.${var.internal_root_dns}:80

Host *.${var.internal_root_dns}
ProxyCommand ssh -F ssh.cfg bastion -W %h:%p
EOF

  description = "The Configuration file for SSH access."
}
