### General
locals {
  network_cidr    = var.network.cidr
  network_name    = var.network.name
  network_dns     = var.network.dns
  network_id      = var.network.id
  locations       = split(",", var.network.locations)
  subnet_ids      = split(",", var.network.subnet_ids)
  image_id        = var.network.image_id
  key_name        = var.network.key_name
  internal_domain = var.network.internal_domain
}

### Pulsar
locals {
  bookie_default = {
    resource_type             = "i3.xlarge"
    resource_count            = 3
    resource_root_volume_size = 64
  }

  broker_default = {
    resource_type             = "c5.2xlarge"
    resource_count            = 3
    resource_root_volume_size = 64
  }

  zookeeper_default = {
    resource_type             = "t3.small"
    resource_count            = 3
    resource_root_volume_size = 64
  }
}

locals {
  bookie_base = {
    default = local.bookie_default

    bai = merge(local.bookie_default, {})

    chiku = merge(local.bookie_default, {})

    sho = merge(local.bookie_default, {})
  }

  broker_base = {
    default = local.broker_default

    bai = merge(local.broker_default, {})

    chiku = merge(local.broker_default, {})

    sho = merge(local.broker_default, {})
  }

  zookeeper_base = {
    default = local.zookeeper_default

    bai = merge(local.zookeeper_default, {})

    chiku = merge(local.zookeeper_default, {})

    sho = merge(local.zookeeper_default, {})
  }
}

locals {
  bookie = merge(
    local.bookie_base[var.base],
    var.bookie
  )

  broker = merge(
    local.broker_base[var.base],
    var.broker
  )

  zookeeper = merge(
    local.zookeeper_base[var.base],
    var.zookeeper
  )
}
