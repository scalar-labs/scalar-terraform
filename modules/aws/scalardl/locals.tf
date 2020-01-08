### General
locals {
  network_cidr      = var.network.cidr
  network_name      = var.network.name
  network_dns       = var.network.dns
  network_id        = var.network.id
  location          = var.network.location
  image_id          = var.network.image_id
  key_name          = var.network.key_name
  bastion_ip        = var.network.bastion_ip
  private_key_path  = var.network.private_key_path
  user_name         = var.network.user_name
  blue_subnet_id    = var.network.blue_subnet_id
  green_subnet_id   = var.network.green_subnet_id
  internal_root_dns = var.network.internal_root_dns

  triggers = [var.cassandra.start_on_initial_boot == true ? var.cassandra.provision_ids : var.network.bastion_provision_id]
}

### default
locals {
  scalardl_default = {
    resource_type             = "t3.medium"
    resource_root_volume_size = 64
    blue_resource_count       = 3
    blue_image_tag            = "1.3.1"
    blue_image_name           = "scalarlabs/scalar-ledger"
    green_resource_count      = 0
    green_image_tag           = "1.3.1"
    replication_factor        = 3
    green_image_name          = "scalarlabs/scalar-ledger"
    target_port               = 50051
    privileged_target_port    = 50052
    listen_port               = 50051
    privileged_listen_port    = 50052
    enable_nlb                = true
    nlb_internal              = true
    nlb_subnet_id             = var.network.private_subnet_id
    enable_tdagent            = true
  }
}

### scalardl
locals {
  scalardl_base = {
    default = local.scalardl_default

    bai = merge(local.scalardl_default, {})

    chiku = merge(local.scalardl_default,
      { resource_type = "t3.large" }
    )

    sho = merge(local.scalardl_default,
      { resource_type = "t3.large" }
    )
  }
}

locals {
  scalardl = merge(
    local.scalardl_base[var.base],
    var.scalardl
  )
}

### envoy
locals {
  envoy_default = {
    resource_type             = "t3.medium"
    resource_count            = 3
    resource_root_volume_size = 64
    target_port               = 50051
    listen_port               = 50051
    subnet_id                 = var.network.private_subnet_id
    nlb_subnet_id             = var.network.public_subnet_id
    enable_nlb                = true
    nlb_internal              = false
    enable_tdagent            = true
    key                       = ""
    cert                      = ""
    tag                       = "v1.10.0"
    image                     = "envoyproxy/envoy"
    tls                       = false
    cert_auto_gen             = true
    custom_config_path        = ""
  }
}

locals {
  envoy_base = {
    default = local.envoy_default

    bai = merge(local.envoy_default, {})

    chiku = merge(local.envoy_default, {})

    sho = merge(local.envoy_default, {})
  }
}

locals {
  envoy = merge(
    local.envoy_base[var.base],
    var.envoy
  )

  envoy_create_count     = local.envoy.resource_count > 0 ? 1 : 0
  envoy_nlb_create_count = local.envoy.enable_nlb ? 1 : 0
}
