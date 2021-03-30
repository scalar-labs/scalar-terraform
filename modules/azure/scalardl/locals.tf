### General
locals {
  network_cidr     = var.network.cidr
  network_name     = var.network.name
  network_dns      = var.network.dns
  network_id       = var.network.id
  region           = var.network.region
  locations        = compact(split(",", var.network.locations))
  image_id         = var.network.image_id
  bastion_ip       = var.network.bastion_ip
  private_key_path = var.network.private_key_path
  public_key_path  = var.network.public_key_path
  user_name        = var.network.user_name
  internal_domain  = var.network.internal_domain

  triggers = [
    length(var.cassandra.provision_ids) > 0 && var.cassandra.start_on_initial_boot ? var.cassandra.provision_ids : var.network.bastion_provision_id
  ]
}

### default
locals {
  scalardl_default = {
    resource_type                       = "Standard_B2s"
    resource_root_volume_size           = 64
    blue_resource_count                 = 3
    blue_image_tag                      = "2.1.0"
    blue_image_name                     = "ghcr.io/scalar-labs/scalar-ledger"
    blue_subnet_id                      = var.network.blue_subnet_id
    blue_discoverable_by_envoy          = true
    blue_container_env_file             = "scalardl_blue_container.env"
    blue_enable_accelerated_networking  = false
    green_resource_count                = 0
    green_image_tag                     = "2.1.0"
    green_image_name                    = "ghcr.io/scalar-labs/scalar-ledger"
    green_subnet_id                     = var.network.green_subnet_id
    green_discoverable_by_envoy         = false
    green_enable_accelerated_networking = false
    green_container_env_file            = "scalardl_green_container.env"
    enable_tdagent                      = true
    database                            = "cassandra"
    database_contact_points             = "cassandra-lb.${local.internal_domain}"
    database_contact_port               = 9042
    database_username                   = "cassandra"
    database_password                   = "cassandra"
    cassandra_replication_factor        = 3
  }
}

### scalardl
locals {
  scalardl_base = {
    default = local.scalardl_default

    bai = merge(local.scalardl_default, {})

    chiku = merge(local.scalardl_default, {})

    sho = merge(local.scalardl_default,
      { resource_type = "Standard_D2s_v3" }
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
    resource_type                 = "Standard_B2s"
    resource_count                = 3
    resource_root_volume_size     = 64
    listen_port                   = 50051
    privileged_listen_port        = 50052
    subnet_id                     = var.network.private_subnet_id
    enable_nlb                    = true
    nlb_internal                  = true
    enable_tdagent                = true
    key                           = ""
    cert                          = ""
    tag                           = "v1.14.1"
    image                         = "envoyproxy/envoy"
    tls                           = false
    cert_auto_gen                 = true
    custom_config_path            = ""
    enable_accelerated_networking = false
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

  envoy_nlb_subnet_id = local.envoy.nlb_internal ? var.network.private_subnet_id : var.network.public_subnet_id
}

locals {
  inventory = <<EOF
[scalardl]
%{for f in azurerm_private_dns_a_record.scalardl_blue_dns.*.name~}
${f}.${local.internal_domain}
%{endfor}
%{~for f in azurerm_private_dns_a_record.scalardl_green_dns.*.name~}
${f}.${local.internal_domain}
%{endfor}
[envoy]
%{for f in azurerm_private_dns_a_record.envoy_dns.*.name~}
${f}.${local.internal_domain}
%{endfor}

[scalardl:vars]
host=scalardl

[envoy:vars]
host=envoy

[all:vars]
base=${var.base}
cloud_provider=azure
EOF
}
