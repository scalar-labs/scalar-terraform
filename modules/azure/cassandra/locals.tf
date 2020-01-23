### General
locals {
  network_cidr      = var.network.cidr
  network_name      = var.network.name
  network_dns       = var.network.dns
  network_id        = var.network.id
  location          = var.network.location
  subnet_id         = var.network.subnet_id
  image_id          = var.network.image_id
  bastion_ip        = var.network.bastion_ip
  private_key_path  = var.network.private_key_path
  public_key_path   = var.network.public_key_path
  user_name         = var.network.user_name
  internal_root_dns = var.network.internal_root_dns

  triggers = [var.network.bastion_provision_id]
}

### cassandra
locals {
  cassandra_default = {
    resource_type                = "Standard_B2ms"
    resource_count               = 3
    resource_root_volume_size    = 64
    enable_data_volume           = false
    data_use_local_volume        = false
    data_remote_volume_size      = 64
    enable_commitlog_volume      = false
    commitlog_use_local_volume   = false
    commitlog_remote_volume_size = ""
    memtable_threshold           = "0.33"
    data_remote_volume_type      = "Premium_LRS"
    commitlog_remote_volume_type = "Premium_LRS"
    enable_tdagent               = true
    start_on_initial_boot        = false
  }
}

locals {
  cassandra_base = {
    default = local.cassandra_default

    bai = merge(local.cassandra_default,
      {
        resource_type              = "Standard_E2s_v3"
        enable_data_volume         = true
        data_remote_volume_size    = 1024
        enable_commitlog_volume    = true
        commitlog_use_local_volume = true
      }
    )

    chiku = merge(local.cassandra_default,
      {
        resource_type              = "Standard_E4s_v3"
        enable_data_volume         = true
        data_remote_volume_size    = 1024
        enable_commitlog_volume    = true
        commitlog_use_local_volume = true
      }
    )

    sho = merge(local.cassandra_default,
      {
        resource_type              = "Standard_L8s"
        enable_data_volume         = true
        data_use_local_volume      = true
        data_remote_volume_size    = ""
        enable_commitlog_volume    = true
        commitlog_use_local_volume = true
        memtable_threshold         = "0.67"
      }
    )
  }
}

locals {
  cassandra = merge(
    local.cassandra_base[var.base],
    var.cassandra
  )
}

### cassy
locals {
  cassy_default = {
    resource_type             = "Standard_D2s_v3"
    resource_count            = 1
    resource_root_volume_size = 64
    enable_tdagent            = true
  }
}

locals {
  cassy_base = {
    default = local.cassy_default

    bai = merge(local.cassy_default, {})

    chiku = merge(local.cassy_default, {})

    sho = merge(local.cassy_default, {})
  }
}

locals {
  cassy = merge(
    local.cassy_base[var.base],
    var.cassy
  )
}

### reaper
locals {
  reaper_default = {
    resource_type             = "Standard_B2s"
    resource_root_volume_size = "64"
    replication_factor        = 3
    resource_count            = 1
    enable_tdagent            = true
  }
}

locals {
  reaper_base = {
    default = local.reaper_default

    bai = merge(local.reaper_default, {})

    chiku = merge(local.reaper_default, {})

    sho = merge(local.reaper_default, {})
  }
}

locals {
  reaper = merge(
    local.reaper_base[var.base],
    var.reaper
  )
}
