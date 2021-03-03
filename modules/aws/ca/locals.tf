### General
locals {
  network_cidr     = var.network.cidr
  network_name     = var.network.name
  network_dns      = var.network.dns
  network_id       = var.network.id
  subnet_ids       = split(",", var.network.subnet_ids)
  image_id         = var.network.image_id
  key_name         = var.network.key_name
  bastion_ip       = var.network.bastion_ip
  private_key_path = var.network.private_key_path
  user_name        = var.network.user_name
  internal_domain  = var.network.internal_domain

  triggers = [var.network.bastion_provision_id]
}

### ca
locals {
  ca_default = {
    resource_type             = "t3.micro"
    resource_count            = 1
    resource_root_volume_size = 16
    enable_tdagent            = true
  }

  ca = merge(local.ca_default, var.ca)
}

locals {
  inventory = <<EOF
[ca]
%{for f in aws_route53_record.ca_dns.*.fqdn~}
${f}
%{endfor}

[ca:vars]
host=ca

[all:vars]
cloud_provider=aws
EOF
}
