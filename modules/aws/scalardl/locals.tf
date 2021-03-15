### General
locals {
  network_cidr       = var.network.cidr
  network_name       = var.network.name
  network_dns        = var.network.dns
  network_id         = var.network.id
  locations          = split(",", var.network.locations)
  image_id           = var.network.image_id
  key_name           = var.network.key_name
  bastion_ip         = var.network.bastion_ip
  private_key_path   = var.network.private_key_path
  user_name          = var.network.user_name
  private_subnet_ids = split(",", var.network.private_subnet_ids)
  public_subnet_ids  = split(",", var.network.public_subnet_ids)
  blue_subnet_ids    = split(",", var.network.blue_subnet_ids)
  green_subnet_ids   = split(",", var.network.green_subnet_ids)
  internal_domain    = var.network.internal_domain
}

### default
locals {
  scalardl_default = {
    resource_type                = "t3.medium"
    resource_root_volume_size    = 64
    blue_resource_count          = 3
    blue_image_tag               = "2.1.0"
    blue_image_name              = "ghcr.io/scalar-labs/scalar-ledger"
    blue_discoverable_by_envoy   = true
    blue_container_env_file      = "scalardl_blue_container.env"
    green_resource_count         = 0
    green_image_tag              = "2.1.0"
    green_image_name             = "ghcr.io/scalar-labs/scalar-ledger"
    green_discoverable_by_envoy  = false
    green_container_env_file     = "scalardl_green_container.env"
    target_port                  = 50051
    privileged_target_port       = 50052
    listen_port                  = 50051
    privileged_listen_port       = 50052
    enable_tdagent               = true
    database                     = "cassandra"
    database_contact_points      = "cassandra-lb.${local.internal_domain}"
    database_contact_port        = 9042
    database_username            = "cassandra"
    database_password            = "cassandra"
    cassandra_replication_factor = 3
  }
}

### scalardl
locals {
  scalardl_base = {
    default = local.scalardl_default

    bai = merge(local.scalardl_default, {})

    chiku = merge(local.scalardl_default, {})

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
    privileged_target_port    = 50052
    listen_port               = 50051
    privileged_listen_port    = 50052
    subnet_ids                = local.private_subnet_ids
    enable_nlb                = true
    nlb_internal              = true
    enable_tdagent            = true
    key                       = ""
    cert                      = ""
    tag                       = "v1.14.1"
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
  envoy_nlb_subnet_ids   = local.envoy.nlb_internal ? slice(local.private_subnet_ids, 0, length(distinct(local.locations))) : slice(local.public_subnet_ids, 0, length(distinct(local.locations)))
}

locals {
  triggers = [
    local.scalardl.database == "cassandra" && var.cassandra.start_on_initial_boot ? var.cassandra.provision_ids : var.network.bastion_provision_id
  ]
}

locals {
  inventory = <<EOF
[scalardl]
%{for f in aws_route53_record.scalardl_blue_dns.*.fqdn~}
${f}
%{endfor}
%{~for f in aws_route53_record.scalardl_green_dns.*.fqdn~}
${f}
%{endfor}
[envoy]
%{for f in aws_route53_record.envoy_dns.*.fqdn~}
${f}
%{endfor}

[scalardl:vars]
host=scalardl

[envoy:vars]
host=envoy

[all:vars]
base=${var.base}
cloud_provider=aws
EOF
}
