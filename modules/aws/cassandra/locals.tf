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
}

### cassandra
locals {
  cassandra_default = {
    resource_type                = "t3.large"
    resource_count               = 3
    resource_root_volume_size    = 64
    enable_data_volume           = false
    data_use_local_volume        = false
    data_remote_volume_size      = 64
    enable_commitlog_volume      = false
    commitlog_use_local_volume   = false
    commitlog_remote_volume_size = ""
    memtable_threshold           = "0.33"
    data_remote_volume_type      = "gp2"
    commitlog_remote_volume_type = "gp2"
    enable_tdagent               = true
    start_on_initial_boot        = false
  }
}

locals {
  cassandra_base = {
    default = local.cassandra_default

    bai = merge(local.cassandra_default,
      {
        resource_type              = "r5d.large"
        enable_data_volume         = true
        data_remote_volume_size    = 1024
        enable_commitlog_volume    = true
        commitlog_use_local_volume = true
      }
    )

    chiku = merge(local.cassandra_default,
      {
        resource_type              = "r5d.xlarge"
        enable_data_volume         = true
        data_remote_volume_size    = 1024
        enable_commitlog_volume    = true
        commitlog_use_local_volume = true
      }
    )

    sho = merge(local.cassandra_default,
      {
        resource_type              = "i3.2xlarge"
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

locals {
  resource_type                = local.cassandra.resource_type
  resource_count               = local.cassandra.resource_count
  resource_root_volume_size    = local.cassandra.resource_root_volume_size
  enable_data_volume           = local.cassandra.enable_data_volume
  data_use_local_volume        = local.cassandra.data_use_local_volume
  data_remote_volume_size      = local.cassandra.data_remote_volume_size
  enable_commitlog_volume      = local.cassandra.enable_commitlog_volume
  commitlog_use_local_volume   = local.cassandra.commitlog_use_local_volume
  commitlog_remote_volume_size = local.cassandra.commitlog_remote_volume_size
  memtable_threshold           = local.cassandra.memtable_threshold
  data_remote_volume_type      = local.cassandra.data_remote_volume_type
  commitlog_remote_volume_type = local.cassandra.commitlog_remote_volume_type
  enable_tdagent               = local.cassandra.enable_tdagent
  start_on_initial_boot        = local.cassandra.start_on_initial_boot
}

### cassy
locals {
  cassy_default = {
    resource_type             = "t3.micro"
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

locals {
  cassy_resource_type             = local.cassy.resource_type
  cassy_resource_count            = local.cassy.resource_count
  cassy_resource_root_volume_size = local.cassy.resource_root_volume_size
  cassy_enable_tdagent            = local.cassy.enable_tdagent
}

### reaper
locals {
  reaper_default = {
    resource_type             = "t3.medium"
    resource_root_volume_size = "64"
    repliation_factor         = 3
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

locals {
  reaper_resource_type             = local.reaper.resource_type
  reaper_resource_root_volume_size = local.reaper.resource_root_volume_size
  reaper_repliation_factor         = local.reaper.repliation_factor
  reaper_resource_count            = local.reaper.resource_count
  reaper_enable_tdagent            = local.reaper.enable_tdagent
}
