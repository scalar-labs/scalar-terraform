resource "null_resource" "wait_for" {
  triggers = {
    network_id = local.network_id
  }
}

module "scalardl_blue" {
  source = "./cluster"

  bastion_ip   = local.bastion_ip
  network_name = local.network_name

  resource_type             = local.scalardl.resource_type
  resource_count            = local.scalardl.blue_resource_count
  resource_cluster_name     = "blue"
  resource_root_volume_size = local.scalardl.resource_root_volume_size
  triggers                  = local.triggers
  location                  = local.location
  private_key_path          = local.private_key_path
  public_key_path           = local.public_key_path
  user_name                 = local.user_name
  subnet_id                 = local.scalardl.blue_subnet_id
  image_id                  = local.image_id
  network_dns               = local.network_dns
  scalardl_image_name       = local.scalardl.blue_image_name
  scalardl_image_tag        = local.scalardl.blue_image_tag
  replication_factor        = local.scalardl.replication_factor
  enable_tdagent            = local.scalardl.enable_tdagent
  availability_set_id       = azurerm_availability_set.scalar_availability_set.id
  internal_domain           = local.internal_domain
}

module "scalardl_green" {
  source = "./cluster"

  bastion_ip   = local.bastion_ip
  network_name = local.network_name

  resource_type             = local.scalardl.resource_type
  resource_count            = local.scalardl.green_resource_count
  resource_cluster_name     = "green"
  resource_root_volume_size = local.scalardl.resource_root_volume_size
  triggers                  = local.triggers
  location                  = local.location
  private_key_path          = local.private_key_path
  public_key_path           = local.public_key_path
  user_name                 = local.user_name
  subnet_id                 = local.scalardl.green_subnet_id
  image_id                  = local.image_id
  network_dns               = local.network_dns
  scalardl_image_name       = local.scalardl.green_image_name
  scalardl_image_tag        = local.scalardl.green_image_tag
  replication_factor        = local.scalardl.replication_factor
  enable_tdagent            = local.scalardl.enable_tdagent
  availability_set_id       = azurerm_availability_set.scalar_availability_set.id
  internal_domain           = local.internal_domain
}

resource "azurerm_availability_set" "scalar_availability_set" {
  depends_on = [null_resource.wait_for]

  name                         = "scalardl-avset"
  location                     = local.location
  resource_group_name          = local.network_name
  platform_fault_domain_count  = 2
  platform_update_domain_count = 2
  managed                      = true
}

resource "azurerm_lb" "scalardl-lb" {
  count = local.scalardl.enable_nlb ? 1 : 0

  name                = "ScalardlLoadBalancer"
  location            = local.location
  resource_group_name = local.network_name

  frontend_ip_configuration {
    name      = "ScalardlLBAddress"
    subnet_id = local.scalardl_nlb_subnet_id
  }
}

resource "azurerm_lb_backend_address_pool" "scalardl-lb-backend-pool" {
  count = local.scalardl.enable_nlb ? 1 : 0

  resource_group_name = local.network_name
  loadbalancer_id     = azurerm_lb.scalardl-lb[count.index].id
  name                = "ScalardlAddressPool"
}

resource "azurerm_lb_rule" "scalardl-lb-rule" {
  count = local.scalardl.enable_nlb ? 1 : 0

  resource_group_name            = local.network_name
  loadbalancer_id                = azurerm_lb.scalardl-lb[count.index].id
  name                           = "ScalardlLBRule"
  protocol                       = "Tcp"
  frontend_port                  = local.scalardl.listen_port
  backend_port                   = local.scalardl.target_port
  frontend_ip_configuration_name = "ScalardlLBAddress"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.scalardl-lb-backend-pool[count.index].id
  probe_id                       = azurerm_lb_probe.scalardl-lb-probe[count.index].id
  idle_timeout_in_minutes        = 6
}

resource "azurerm_lb_rule" "scalardl-privileged-lb-rule" {
  count = local.scalardl.enable_nlb ? 1 : 0

  resource_group_name            = local.network_name
  loadbalancer_id                = azurerm_lb.scalardl-lb[count.index].id
  name                           = "ScalardlPrivilegedLBRule"
  protocol                       = "Tcp"
  frontend_port                  = local.scalardl.privileged_listen_port
  backend_port                   = local.scalardl.privileged_target_port
  frontend_ip_configuration_name = "ScalardlLBAddress"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.scalardl-lb-backend-pool[count.index].id
  probe_id                       = azurerm_lb_probe.scalardl-privileged-lb-probe[count.index].id
  idle_timeout_in_minutes        = 6
}

resource "azurerm_lb_probe" "scalardl-lb-probe" {
  count = local.scalardl.enable_nlb ? 1 : 0

  resource_group_name = local.network_name
  loadbalancer_id     = azurerm_lb.scalardl-lb[count.index].id
  name                = "scalardl-running-probe"
  port                = local.scalardl.target_port
}

resource "azurerm_lb_probe" "scalardl-privileged-lb-probe" {
  count = local.scalardl.enable_nlb ? 1 : 0

  resource_group_name = local.network_name
  loadbalancer_id     = azurerm_lb.scalardl-lb[count.index].id
  name                = "scalardl-privleged-running-probe"
  port                = local.scalardl.privileged_target_port
}

resource "azurerm_network_interface_backend_address_pool_association" "scalardl-lb-blue-association" {
  count = local.scalardl.enable_nlb ? local.scalardl.blue_resource_count : 0

  network_interface_id    = module.scalardl_blue.network_interface_ids[count.index]
  ip_configuration_name   = "ipconfig${count.index}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.scalardl-lb-backend-pool[0].id
}

resource "azurerm_network_interface_backend_address_pool_association" "scalardl-lb-green-association" {
  count = local.scalardl.enable_nlb ? local.scalardl.green_resource_count : 0

  network_interface_id    = module.scalardl_green.network_interface_ids[count.index]
  ip_configuration_name   = "ipconfig${count.index}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.scalardl-lb-backend-pool[0].id
}

resource "azurerm_private_dns_a_record" "scalardl-blue-dns" {
  count = local.scalardl.blue_resource_count

  name                = "scalardl-blue-${count.index + 1}"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  records = [module.scalardl_blue.network_interface_private_ip[count.index]]
}

resource "azurerm_private_dns_a_record" "scalardl-green-dns" {
  count = local.scalardl.green_resource_count

  name                = "scalardl-green-${count.index + 1}"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  records = [module.scalardl_green.network_interface_private_ip[count.index]]
}

resource "azurerm_private_dns_a_record" "scalardl-dns-lb" {
  count = local.scalardl.enable_nlb ? 1 : 0

  name                = "scalardl-lb"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  records = azurerm_lb.scalardl-lb[count.index].private_ip_addresses
}

resource "azurerm_private_dns_srv_record" "node-exporter-blue-dns-srv" {
  count = local.scalardl.blue_resource_count > 0 ? 1 : 0

  name                = "_node-exporter._tcp.scalardl-blue"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  dynamic record {
    for_each = azurerm_private_dns_a_record.scalardl-blue-dns.*.name

    content {
      priority = 0
      weight   = 0
      port     = 9100
      target   = "${record.value}.${local.internal_domain}"
    }
  }
}

resource "azurerm_private_dns_srv_record" "node-exporter-green-dns-srv" {
  count = local.scalardl.green_resource_count > 0 ? 1 : 0

  name                = "_node-exporter._tcp.scalardl-green"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  dynamic record {
    for_each = azurerm_private_dns_a_record.scalardl-green-dns.*.name

    content {
      priority = 0
      weight   = 0
      port     = 9100
      target   = "${record.value}.${local.internal_domain}"
    }
  }
}

resource "azurerm_private_dns_srv_record" "cadvisor-blue-dns-srv" {
  count = local.scalardl.blue_resource_count > 0 ? 1 : 0

  name                = "_cadvisor._tcp.scalardl-blue"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  dynamic record {
    for_each = azurerm_private_dns_a_record.scalardl-blue-dns.*.name

    content {
      priority = 0
      weight   = 0
      port     = 18080
      target   = "${record.value}.${local.internal_domain}"
    }
  }
}

resource "azurerm_private_dns_srv_record" "cadvisor-green-dns-srv" {
  count = local.scalardl.green_resource_count > 0 ? 1 : 0

  name                = "_cadvisor._tcp.scalardl-green"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  dynamic record {
    for_each = azurerm_private_dns_a_record.scalardl-green-dns.*.name

    content {
      priority = 0
      weight   = 0
      port     = 18080
      target   = "${record.value}.${local.internal_domain}"
    }
  }
}

resource "azurerm_private_dns_srv_record" "scalardl-dns-srv" {
  count = local.scalardl.green_resource_count > 0 || local.scalardl.blue_resource_count > 0 ? 1 : 0

  name                = "_scalardl._tcp.scalardl-service"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  dynamic record {
    for_each = concat(azurerm_private_dns_a_record.scalardl-blue-dns.*.name, azurerm_private_dns_a_record.scalardl-green-dns.*.name)

    content {
      priority = 0
      weight   = 0
      port     = 50053
      target   = "${record.value}.${local.internal_domain}"
    }
  }
}
