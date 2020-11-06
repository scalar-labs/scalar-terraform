### General
locals {
  network_cidr     = var.network.cidr
  network_name     = var.network.name
  network_dns      = var.network.dns
  network_id       = var.network.id
  region           = var.network.region
  locations        = compact(split(",", var.network.locations))
  subnet_id        = var.network.subnet_id
  image_id         = var.network.image_id
  bastion_ip       = var.network.bastion_ip
  public_key_path  = var.network.public_key_path
  private_key_path = var.network.private_key_path
  user_name        = var.network.user_name
  internal_domain  = var.network.internal_domain
  triggers         = [var.network.bastion_provision_id]

  cassandra_resource_count      = lookup(var.cassandra, "resource_count", 0)
  scalardl_blue_resource_count  = lookup(var.scalardl, "blue_resource_count", 0)
  scalardl_green_resource_count = lookup(var.scalardl, "green_resource_count", 0)
  scalardl_replication_factor   = lookup(var.scalardl, "cassandra_replication_factor", 0)
}

### default
locals {
  monitor_default = {
    resource_type                         = "Standard_B2s"
    resource_root_volume_size             = 64
    resource_count                        = 1
    active_offset                         = 0
    log_volume_size                       = 500
    log_volume_type                       = "Standard_LRS"
    enable_tdagent                        = true
    set_public_access                     = false
    remote_port                           = 9090
    enable_accelerated_networking         = false
    log_retention_period_days             = 30
    log_archive_storage_base_uri          = ""
    prometheus_data_retention_period_days = "90"
  }
}

### monitor
locals {
  monitor_base = {
    default = local.monitor_default

    bai = merge(local.monitor_default, {})

    chiku = merge(local.monitor_default, {})

    sho = merge(local.monitor_default, {})
  }
}

locals {
  monitor = merge(
    local.monitor_base[var.base],
    var.monitor
  )

  log_archive_storage        = regex("^(?:https://(?P<storage_account>[^.]+)[^/]+(?:/(?P<container_name>[^.]+)))?", local.monitor.log_archive_storage_base_uri)
  enable_log_archive_storage = local.log_archive_storage.storage_account != null
  log_archive_storage_info   = local.enable_log_archive_storage ? "azure_blob:${local.log_archive_storage.storage_account}:${local.log_archive_storage.container_name}" : ""
}
