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
  subnet_map = {
    public         = cidrsubnets(cidrsubnet(local.network.cidr, 8, 0), 2, 2, 2)
    private        = cidrsubnets(cidrsubnet(local.network.cidr, 8, 1), 2, 2, 2)
    cassandra      = cidrsubnets(cidrsubnet(local.network.cidr, 8, 2), 2, 2, 2)
    scalardl_blue  = cidrsubnets(cidrsubnet(local.network.cidr, 8, 3), 2, 2, 2)
    scalardl_green = cidrsubnets(cidrsubnet(local.network.cidr, 8, 4), 2, 2, 2)
  }
}
