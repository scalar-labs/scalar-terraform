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
