### General
locals {
  network_cidr     = var.network.cidr
  network_name     = var.network.name
  network_dns      = var.network.dns
  network_id       = var.network.id
  subnet_id        = var.network.subnet_id
  image_id         = var.network.image_id
  key_name         = var.network.key_name
  bastion_ip       = var.network.bastion_ip
  private_key_path = var.network.private_key_path
  user_name        = var.network.user_name

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
