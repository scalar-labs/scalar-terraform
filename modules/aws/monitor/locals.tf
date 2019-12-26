### General
locals {
  network_cidr     = var.network.network_cidr
  network_name     = var.network.network_name
  network_dns      = var.network.network_dns
  network_id       = var.network.network_id
  location         = var.network.location
  subnet_id        = var.network.subnet_id
  image_id         = var.network.image_id
  triggers         = var.network.triggers
  key_name         = var.network.key_name
  bastion_ip       = var.network.bastion_ip
  private_key_path = var.network.private_key_path
  user_name        = var.network.user_name

  triggers = var.network.bastion_provision_id

  cassandra_resource_count = var.cassandra.cassandra_resource_count

  scalardl_blue_resource_count  = var.scalardl.scalardl_blue_resource_count
  scalardl_green_resource_count = var.scalardl.scalardl_green_resource_count
  scalardl_replication_factor   = var.scalardl.scalardl_replication_factor
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
    #replication_factor        = 3
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
}

locals {
  resource_type             = local.monitor.resource_type
  resource_count            = local.monitor.resource_count
  resource_root_volume_size = local.monitor.resource_root_volume_size
  enable_log_volume         = local.monitor.enable_log_volume
  log_volume_size           = local.monitor.log_volume_size
  log_volume_type           = local.monitor.log_volume_type
  #replication_factor        = local.monitor.replication_factor

  enable_tdagent = local.monitor.enable_tdagent
}
