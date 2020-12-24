### default
locals {
  network_default = {
    bastion_resource_type                 = "Standard_B1s"
    bastion_resource_count                = 1
    bastion_access_cidr                   = "0.0.0.0/0"
    bastion_resource_root_volume_size     = 32
    bastion_enable_tdagent                = true
    bastion_enable_accelerated_networking = false
    user_name                             = "centos"
    cidr                                  = "10.42.0.0/16"
    image_id                              = "CentOS"
  }

  network = merge(
    local.network_default,
    var.network
  )
}

locals {
  subnet = {
    public         = {
      address_prefix    = cidrsubnet(local.network.cidr, 8, 0)
      service_endpoints = []
    }
    private        = {
      address_prefix    = cidrsubnet(local.network.cidr, 8, 1)
      service_endpoints = []
    }
    cassandra      = {
      address_prefix    = cidrsubnet(local.network.cidr, 8, 2)
      service_endpoints = []
    }
    scalardl_blue  = {
      address_prefix    = cidrsubnet(local.network.cidr, 8, 3)
      service_endpoints = var.use_cosmosdb ? ["Microsoft.AzureCosmosDB"] : []
    }
    scalardl_green = {
      address_prefix    = cidrsubnet(local.network.cidr, 8, 4)
      service_endpoints = var.use_cosmosdb ? ["Microsoft.AzureCosmosDB"] : []
    }
  }

  locations = compact(var.locations)
}
