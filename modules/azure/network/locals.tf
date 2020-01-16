### default
locals {
  network_default = {
    bastion_resource_type     = "Standard_D2s_v3"
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
  subnet = {
    public    = cidrsubnet(local.network.cidr, 8, 0)
    private   = cidrsubnet(local.network.cidr, 8, 1)
    cassandra = cidrsubnet(local.network.cidr, 8, 2)
    blue      = cidrsubnet(local.network.cidr, 8, 3)
    green     = cidrsubnet(local.network.cidr, 8, 4)
  }
}
