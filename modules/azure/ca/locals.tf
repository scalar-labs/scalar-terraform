### General
locals {
  network_cidr     = var.network.cidr
  network_name     = var.network.name
  network_dns      = var.network.dns
  network_id       = var.network.id
  region           = var.network.region
  locations        = compact(split(",", var.network.locations))
  subnet_id        = var.network.subnet_id
  image_id         = var.network.image_id
  bastion_ip       = var.network.bastion_ip
  public_key_path  = var.network.public_key_path
  private_key_path = var.network.private_key_path
  user_name        = var.network.user_name
  internal_domain  = var.network.internal_domain

  triggers = [var.network.bastion_provision_id]
}

### ca
locals {
  ca_default = {
    resource_type                 = "Standard_B2s"
    resource_count                = 1
    resource_root_volume_size     = 30
    enable_tdagent                = true
    enable_accelerated_networking = false
  }

  ca = merge(local.ca_default, var.ca)
}
