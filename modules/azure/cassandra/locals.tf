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
  vm_os_publisher  = var.network.vm_os_publisher
  vm_os_offer      = var.network.vm_os_offer
  vm_os_sku        = var.network.vm_os_sku
  bastion_ip       = var.network.bastion_ip
  private_key_path = var.network.private_key_path
  public_key_path  = var.network.public_key_path
  user_name        = var.network.user_name
  internal_domain  = var.network.internal_domain

  triggers = [var.network.bastion_provision_id]
}

### cassandra
locals {
  cassandra_default = {
    resource_type                 = "Standard_B2ms"
    resource_count                = 3
    resource_root_volume_size     = 64
    enable_data_volume            = false
    data_use_local_volume         = false
    data_remote_volume_size       = 64
    enable_commitlog_volume       = false
    commitlog_use_local_volume    = false
    commitlog_remote_volume_size  = ""
    memtable_threshold            = "0.33"
    data_remote_volume_type       = "Premium_LRS"
    commitlog_remote_volume_type  = "Premium_LRS"
    enable_tdagent                = true
    start_on_initial_boot         = false
    use_agent                     = true
    enable_accelerated_networking = false
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
    image_tag                     = "1.2.0"
    resource_type                 = "Standard_B2ms"
    resource_count                = 1
    resource_root_volume_size     = 64
    enable_tdagent                = true
    enable_accelerated_networking = false
    use_managed_identity          = true
    storage_base_uri              = ""
    storage_type                  = ""
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
    resource_type                 = "Standard_B2ms"
    resource_root_volume_size     = "64"
    replication_factor            = 3
    resource_count                = 1
    enable_tdagent                = true
    cassandra_username            = "cassandra"
    cassandra_password            = "cassandra"
    enable_accelerated_networking = false
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
  inventory = <<EOF
[cassandra]
%{for f in azurerm_private_dns_a_record.cassandra_dns.*.name~}
${f}.${local.internal_domain}
%{endfor}
[cassy]
%{for f in azurerm_private_dns_a_record.cassy_dns.*.name~}
${f}.${local.internal_domain}
%{endfor}
[reaper]
%{for f in azurerm_private_dns_a_record.reaper_dns.*.name~}
${f}.${local.internal_domain}
%{endfor}

[cassandra:vars]
host=cassandra

[cassy:vars]
host=cassy

[reaper:vars]
host=reaper

[all:vars]
base=${var.base}
cloud_provider=azure
EOF
}
