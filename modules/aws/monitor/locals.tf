### General
locals {
  network_cidr      = var.network.cidr
  network_name      = var.network.name
  network_dns       = var.network.dns
  network_id        = var.network.id
  location          = var.network.location
  subnet_id         = var.network.subnet_id
  image_id          = var.network.image_id
  key_name          = var.network.key_name
  bastion_ip        = var.network.bastion_ip
  private_key_path  = var.network.private_key_path
  user_name         = var.network.user_name
  internal_root_dns = var.network.internal_root_dns
  triggers          = [var.network.bastion_provision_id]

  cassandra_resource_count      = var.cassandra.resource_count
  scalardl_blue_resource_count  = var.scalardl.blue_resource_count
  scalardl_green_resource_count = var.scalardl.green_resource_count
  scalardl_replication_factor   = var.scalardl.replication_factor
}

### default
locals {
  monitor_default = {
    resource_type             = "t3.small"
    resource_root_volume_size = 64
    resource_count            = 1
    enable_log_volume         = true
    log_volume_size           = 500
    log_volume_type           = "sc1"
    enable_tdagent            = true
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

  monitor_create_count        = local.monitor.resource_count > 0 ? 1 : 0
  monitor_volume_create_count = local.monitor.enable_tdagent && local.monitor.enable_log_volume ? local.monitor.resource_count : 0
}
