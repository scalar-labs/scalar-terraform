### General
locals {
  network_cidr        = var.network.cidr
  network_name        = var.network.name
  network_dns         = var.network.dns
  network_id          = var.network.id
  region              = var.network.region
  node_pool_subnet_id = var.kubernetes.node_pool_subnet_id
  bastion_ip          = var.network.bastion_ip
  internal_domain     = var.network.internal_domain
  triggers            = [var.network.bastion_provision_id]
}

### Cosmos DB
locals {
  cosmosdb_default = {
  }
}

locals {
  cosmosdb_base = {
    default = local.cosmosdb_default

    bai = merge(local.cosmosdb_default,
      {
      }
    )

    chiku = merge(local.cosmosdb_default,
      {
      }
    )

    sho = merge(local.cosmosdb_default,
      {
      }
    )
  }
}

locals {
  cosmosdb = merge(
    local.cosmosdb_base[var.base],
    var.cosmosdb
  )
}
