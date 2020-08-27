### General
locals {
  network_cidr     = var.network.cidr
  network_name     = var.network.name
  network_dns      = var.network.dns
  network_id       = var.network.id
  locations        = split(",", var.network.locations)
  subnet_ids       = split(",", var.network.subnet_ids)
  image_id         = var.network.image_id
  key_name         = var.network.key_name
  bastion_ip       = var.network.bastion_ip
  private_key_path = var.network.private_key_path
  user_name        = var.network.user_name
  internal_domain  = var.network.internal_domain
  triggers         = [var.network.bastion_provision_id]

  cassandra_resource_count      = lookup(var.cassandra, "resource_count", 0)
  scalardl_blue_resource_count  = lookup(var.scalardl, "blue_resource_count", 0)
  scalardl_green_resource_count = lookup(var.scalardl, "green_resource_count", 0)
  scalardl_replication_factor   = lookup(var.scalardl, "replication_factor", 0)
}

### default
locals {
  monitor_default = {
    resource_type             = "t3.small"
    resource_root_volume_size = 64
    resource_count            = 1
    active_offset             = 0
    encrypt_volume            = true
    enable_log_volume         = true
    log_volume_size           = 500
    log_volume_type           = "sc1"
    enable_tdagent            = true
    log_retention_period_days = 30
  }
}

### scalardl
locals {
  monitor_base = {
    default = local.monitor_default

    bai = merge(local.monitor_default,
      { resource_type = "t3.medium" }
    )

    chiku = merge(local.monitor_default,
      { resource_type = "t3.large" }
    )

    sho = merge(local.monitor_default,
      { resource_type = "t3.large" }
    )
  }
}

locals {
  monitor = merge(
    local.monitor_base[var.base],
    var.monitor
  )
}
