output "network_cidr" {
  value       = module.vpc.vpc_cidr_block
  description = "Network CIDR address space."
}

output "network_name" {
  value       = module.name_generator.name
  description = "Short name to identify environment."
}

output "network_dns" {
  value       = module.dns.dns_zone_id
  description = "The VPC network DNS ID."
}

output "network_id" {
  value       = module.vpc.vpc_id
  description = "The VPC network ID."
}

output "subnet_map" {
  value = {
    public         = module.vpc.public_subnets[0]
    private        = module.vpc.private_subnets[0]
    cassandra      = module.vpc.private_subnets[1]
    scalardl_blue  = module.vpc.private_subnets[2]
    scalardl_green = module.vpc.private_subnets[3]
  }
  description = "The subnet map of VPC network."
}

output "image_id" {
  value       = module.image.image_id
  description = "The image id to initiate."
}

output "bastion_provision_id" {
  value       = module.bastion.bastion_provision_id
  description = "The provision id of bastion."
}

output "key_name" {
  value       = module.bastion.key_name
  description = "The key-name of the AWS managed ssh key_pair."
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

output "additional_public_keys_path" {
  value       = abspath(pathexpand(var.additional_public_keys_path))
  description = "The path to the additional public key for SSH access."
}

output "internal_domain" {
  value       = var.internal_domain
  description = "The internal domain for setting srv record"
}

output "ssh_config" {
  value = <<EOF
Host *
User ${local.network.user_name}
UserKnownHostsFile /dev/null
StrictHostKeyChecking no

Host bastion
HostName ${module.bastion.bastion_host_ips[0]}
LocalForward 8000 monitor.${var.internal_domain}:80

Host *.${var.internal_domain}
ProxyCommand ssh -F ssh.cfg bastion -W %h:%p
EOF

  description = "The Configuration file for SSH access."
}
