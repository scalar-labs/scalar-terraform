resource "null_resource" "wait_for" {
  triggers = {
    network_id = local.network_id
  }
}

module "scalardl_blue" {
  source = "./cluster"

  bastion_ip   = local.bastion_ip
  network_name = local.network_name

  resource_type                 = local.scalardl.resource_type
  resource_count                = local.scalardl.blue_resource_count
  resource_cluster_name         = "blue"
  resource_root_volume_size     = local.scalardl.resource_root_volume_size
  triggers                      = local.triggers
  region                        = local.region
  private_key_path              = local.private_key_path
  public_key_path               = local.public_key_path
  user_name                     = local.user_name
  subnet_id                     = local.scalardl.blue_subnet_id
  image_id                      = local.image_id
  network_dns                   = local.network_dns
  scalardl_image_name           = local.scalardl.blue_image_name
  scalardl_image_tag            = local.scalardl.blue_image_tag
  replication_factor            = local.scalardl.replication_factor
  enable_tdagent                = local.scalardl.enable_tdagent
  availability_set_id           = azurerm_availability_set.scalar_availability_set.id
  internal_domain               = local.internal_domain
  cassandra_username            = local.scalardl.cassandra_username
  cassandra_password            = local.scalardl.cassandra_password
  enable_accelerated_networking = local.scalardl.blue_enable_accelerated_networking
}

module "scalardl_green" {
  source = "./cluster"

  bastion_ip   = local.bastion_ip
  network_name = local.network_name

  resource_type                 = local.scalardl.resource_type
  resource_count                = local.scalardl.green_resource_count
  resource_cluster_name         = "green"
  resource_root_volume_size     = local.scalardl.resource_root_volume_size
  triggers                      = local.triggers
  region                        = local.region
  private_key_path              = local.private_key_path
  public_key_path               = local.public_key_path
  user_name                     = local.user_name
  subnet_id                     = local.scalardl.green_subnet_id
  image_id                      = local.image_id
  network_dns                   = local.network_dns
  scalardl_image_name           = local.scalardl.green_image_name
  scalardl_image_tag            = local.scalardl.green_image_tag
  replication_factor            = local.scalardl.replication_factor
  enable_tdagent                = local.scalardl.enable_tdagent
  availability_set_id           = azurerm_availability_set.scalar_availability_set.id
  internal_domain               = local.internal_domain
  cassandra_username            = local.scalardl.cassandra_username
  cassandra_password            = local.scalardl.cassandra_password
  enable_accelerated_networking = local.scalardl.green_enable_accelerated_networking
}

resource "azurerm_availability_set" "scalar_availability_set" {
  depends_on = [null_resource.wait_for]

  name                         = "scalardl-avset"
  location                     = local.region
  resource_group_name          = local.network_name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
}

resource "azurerm_private_dns_a_record" "scalardl_blue_dns" {
  count = local.scalardl.blue_resource_count

  name                = "scalardl-blue-${count.index + 1}"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  records = [module.scalardl_blue.network_interface_private_ip[count.index]]
}

resource "azurerm_private_dns_a_record" "scalardl_green_dns" {
  count = local.scalardl.green_resource_count

  name                = "scalardl-green-${count.index + 1}"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  records = [module.scalardl_green.network_interface_private_ip[count.index]]
}

resource "azurerm_private_dns_a_record" "scalardl_dns" {
  count = local.scalardl.green_resource_count > 0 || local.scalardl.blue_resource_count > 0 ? 1 : 0

  name                = "scalardl"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  records = concat(
    local.scalardl.blue_discoverable_by_envoy ? module.scalardl_blue.network_interface_private_ip : [],
    local.scalardl.green_discoverable_by_envoy ? module.scalardl_green.network_interface_private_ip : []
  )
}

resource "azurerm_private_dns_srv_record" "node_exporter_blue_dns_srv" {
  count = local.scalardl.blue_resource_count > 0 ? 1 : 0

  name                = "_node-exporter._tcp.scalardl-blue"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  dynamic record {
    for_each = azurerm_private_dns_a_record.scalardl_blue_dns.*.name

    content {
      priority = 0
      weight   = 0
      port     = 9100
      target   = "${record.value}.${local.internal_domain}"
    }
  }
}

resource "azurerm_private_dns_srv_record" "node_exporter_green_dns_srv" {
  count = local.scalardl.green_resource_count > 0 ? 1 : 0

  name                = "_node-exporter._tcp.scalardl-green"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  dynamic record {
    for_each = azurerm_private_dns_a_record.scalardl_green_dns.*.name

    content {
      priority = 0
      weight   = 0
      port     = 9100
      target   = "${record.value}.${local.internal_domain}"
    }
  }
}

resource "azurerm_private_dns_srv_record" "cadvisor_blue_dns_srv" {
  count = local.scalardl.blue_resource_count > 0 ? 1 : 0

  name                = "_cadvisor._tcp.scalardl-blue"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  dynamic record {
    for_each = azurerm_private_dns_a_record.scalardl_blue_dns.*.name

    content {
      priority = 0
      weight   = 0
      port     = 18080
      target   = "${record.value}.${local.internal_domain}"
    }
  }
}

resource "azurerm_private_dns_srv_record" "cadvisor_green_dns_srv" {
  count = local.scalardl.green_resource_count > 0 ? 1 : 0

  name                = "_cadvisor._tcp.scalardl-green"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  dynamic record {
    for_each = azurerm_private_dns_a_record.scalardl_green_dns.*.name

    content {
      priority = 0
      weight   = 0
      port     = 18080
      target   = "${record.value}.${local.internal_domain}"
    }
  }
}

resource "azurerm_private_dns_srv_record" "scalardl_dns_srv" {
  count = local.scalardl.green_resource_count > 0 || local.scalardl.blue_resource_count > 0 ? 1 : 0

  name                = "_scalardl._tcp.scalardl-service"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  dynamic record {
    for_each = concat(azurerm_private_dns_a_record.scalardl_blue_dns.*.name, azurerm_private_dns_a_record.scalardl_green_dns.*.name)

    content {
      priority = 0
      weight   = 0
      port     = 50053
      target   = "${record.value}.${local.internal_domain}"
    }
  }
}
