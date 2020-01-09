output "network_cidr" {
  value = module.vpc.vpc_cidr_block
}

output "network_name" {
  value = module.name_generator.name
}

output "network_dns" {
  value = module.dns.dns_zone_id
}

output "network_id" {
  value = module.vpc.vpc_id
}

output "cassandra_subnet_id" {
  value = module.vpc.private_subnets[1]
}

output "scalardl_nlb_subnet_id" {
  value = module.vpc.private_subnets[0]
}

output "scalardl_blue_subnet_id" {
  value = module.vpc.private_subnets[2]
}

output "scalardl_green_subnet_id" {
  value = module.vpc.private_subnets[3]
}

output "image_id" {
  value = module.image.image_id
}

output "bastion_provision_id" {
  value = module.bastion.bastion_provision_id
}

output "key_name" {
  value = module.bastion.key_name
}

output "bastion_ip" {
  value = module.bastion.bastion_host_ips[0]
}

output "location" {
  value = var.location
}

output "user_name" {
  value = local.network.user_name
}

output "private_key_path" {
  value = abspath(pathexpand(var.private_key_path))
}

output "internal_root_dns" {
  value = var.internal_root_dns
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
}
