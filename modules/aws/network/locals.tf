### default
locals {
  network_default = {
    bastion_resource_type     = "t3.micro"
    bastion_resource_count    = 1
    bastion_access_cidr       = "0.0.0.0/0"
    resource_root_volume_size = 16
    bastion_enable_tdagent    = true
    user_name                 = "centos"
    cidr                      = "10.42.0.0/16"
  }
}

locals {
  network = merge(
    local.network_default,
    var.network
  )
}

locals {
  bastion_resource_type     = local.network.bastion_resource_type
  bastion_resource_count    = local.network.bastion_resource_count
  resource_root_volume_size = local.network.resource_root_volume_size
  bastion_access_cidr       = local.network.bastion_access_cidr
  bastion_enable_tdagent    = local.network.bastion_enable_tdagent
  user_name                 = local.network.user_name
  cidr                      = local.network.cidr
}
