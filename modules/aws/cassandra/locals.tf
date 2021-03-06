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

  triggers = [var.network.bastion_provision_id]
}

### cassandra
locals {
  cassandra_default = {
    resource_type                = "t3.large"
    resource_count               = 3
    resource_root_volume_size    = 64
    encrypt_volume               = true
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

### cassy
locals {
  cassy_default = {
    image_tag                 = "1.2.0"
    resource_type             = "t3.medium"
    resource_count            = 1
    resource_root_volume_size = 64
    enable_tdagent            = true
    storage_base_uri          = ""
    storage_type              = ""
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
    resource_type             = "t3.medium"
    resource_root_volume_size = "64"
    replication_factor        = 3
    resource_count            = 1
    enable_tdagent            = true
    cassandra_username        = "cassandra"
    cassandra_password        = "cassandra"
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
%{for f in aws_route53_record.cassandra_dns.*.fqdn~}
${f}
%{endfor}
[cassy]
%{for f in aws_route53_record.cassy_dns.*.fqdn~}
${f}
%{endfor}
[reaper]
%{for f in aws_route53_record.reaper_dns.*.fqdn~}
${f}
%{endfor}

[cassandra:vars]
host=cassandra

[cassy:vars]
host=cassy

[reaper:vars]
host=reaper

[all:vars]
base=${var.base}
cloud_provider=aws
EOF
}
