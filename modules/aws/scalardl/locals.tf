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
  nlb_subnet_id    = var.network.nlb_subnet_id
  blue_subnet_id   = var.network.blue_subnet_id
  green_subnet_id  = var.network.green_subnet_id
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

locals {
  scalardl_resource_type             = local.scalardl.resource_type
  scalardl_resource_root_volume_size = local.scalardl.resource_root_volume_size
  scalardl_blue_resource_count       = local.scalardl.blue_resource_count
  scalardl_blue_image_tag            = local.scalardl.blue_image_tag
  scalardl_blue_image_name           = local.scalardl.blue_image_name
  scalardl_green_resource_count      = local.scalardl.green_resource_count
  scalardl_green_image_tag           = local.scalardl.green_image_tag
  scalardl_replication_factor        = local.scalardl.replication_factor
  scalardl_green_image_name          = local.scalardl.green_image_name
  scalardl_target_port               = local.scalardl.target_port
  scalardl_privileged_target_port    = local.scalardl.privileged_target_port
  scalardl_enable_nlb                = local.scalardl.enable_nlb
  scalardl_nlb_internal              = local.scalardl.nlb_internal
  scalardl_enable_tdagent            = local.scalardl.enable_tdagent
  scalardl_listen_port               = local.scalardl.listen_port
  scalardl_privileged_listen_port    = local.scalardl.privileged_listen_port
}


### envoy
locals {
  envoy_default = {
    resource_type             = "t3.medium"
    resource_count            = 3
    resource_root_volume_size = 64
    target_port               = 50051
    listen_port               = 50051
    nlb_subnet_id             = ""
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
}

locals {
  envoy_resource_type             = local.envoy.resource_type
  envoy_resource_root_volume_size = local.envoy.resource_root_volume_size
  envoy_resource_count            = local.envoy.resource_count
  envoy_target_port               = local.envoy.target_port
  envoy_listen_port               = local.envoy.listen_port
  envoy_enable_nlb                = local.envoy.enable_nlb
  envoy_nlb_internal              = local.envoy.nlb_internal
  envoy_enable_tdagent            = local.envoy.enable_tdagent
  envoy_nlb_subnet_id             = local.envoy.nlb_subnet_id
  envoy_key                       = local.envoy.key
  envoy_cert                      = local.envoy.cert
  envoy_tag                       = local.envoy.tag
  envoy_image                     = local.envoy.image
  envoy_tls                       = local.envoy.tls
  envoy_cert_auto_gen             = local.envoy.cert_auto_gen
  envoy_custom_config_path        = local.envoy.custom_config_path
}
