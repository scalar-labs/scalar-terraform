resource "null_resource" "envoy_wait_for" {
  triggers = {
    network_id = local.network_id
  }
}

module "envoy_cluster" {
  source = "github.com/scalar-labs/terraform-azurerm-compute?ref=upgrade/k8s_version"

  nb_instances                  = local.envoy.resource_count
  admin_username                = local.user_name
  resource_group_name           = local.network_name
  location                      = local.region
  availability_zones            = local.locations
  vm_hostname                   = "envoy"
  nb_public_ip                  = "0"
  vm_os_simple                  = local.image_id
  vm_os_publisher               = local.vm_os_publisher
  vm_os_offer                   = local.vm_os_offer
  vm_os_sku                     = local.vm_os_sku
  vnet_subnet_id                = local.envoy.subnet_id
  vm_size                       = local.envoy.resource_type
  ssh_key                       = local.public_key_path
  storage_account_type          = "StandardSSD_LRS"
  storage_os_disk_size          = local.envoy.resource_root_volume_size
  delete_os_disk_on_termination = true
  remote_port                   = 50051
  enable_accelerated_networking = local.envoy.enable_accelerated_networking
}

module "envoy_provision" {
  source = "../../universal/envoy"

  vm_ids              = module.envoy_cluster.vm_ids
  bastion_host_ip     = local.bastion_ip
  host_list           = module.envoy_cluster.network_interface_private_ip
  user_name           = local.user_name
  private_key_path    = local.private_key_path
  provision_count     = local.envoy.resource_count
  key                 = local.envoy.key
  cert                = local.envoy.cert
  envoy_tls           = local.envoy.tls
  envoy_cert_auto_gen = local.envoy.cert_auto_gen
  envoy_tag           = local.envoy.tag
  envoy_image         = local.envoy.image
  enable_tdagent      = local.envoy.enable_tdagent
  custom_config_path  = local.envoy.custom_config_path
  internal_domain     = local.internal_domain
}

resource "azurerm_network_security_rule" "envoy_privileged_nsg" {
  count = local.envoy.resource_count > 0 ? 1 : 0

  name                        = "allow_remote_50052_in_all"
  description                 = "Allow remote protocol in from all locations"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = 50052
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = local.network_name
  network_security_group_name = module.envoy_cluster.network_security_group_name
}

resource "azurerm_public_ip" "envoy_public_ip" {
  count      = local.envoy.enable_nlb && !local.envoy.nlb_internal ? 1 : 0
  depends_on = [null_resource.envoy_wait_for]

  name                = "PublicIPForEnvoy"
  domain_name_label   = "envoy-${local.network_name}"
  location            = local.region
  sku                 = "Standard"
  resource_group_name = local.network_name
  allocation_method   = "Static"
}

resource "azurerm_lb" "envoy_lb" {
  count = local.envoy.enable_nlb ? 1 : 0

  name                = "EnvoyLoadBalancer"
  location            = local.region
  resource_group_name = local.network_name
  sku                 = "Standard"

  frontend_ip_configuration {
    name                          = "EnvoyLBAddress"
    public_ip_address_id          = local.envoy.nlb_internal ? "" : azurerm_public_ip.envoy_public_ip[count.index].id
    subnet_id                     = local.envoy.nlb_internal ? local.envoy_nlb_subnet_id : ""
    private_ip_address_allocation = "dynamic"
  }
}

resource "azurerm_lb_backend_address_pool" "envoy_lb_pool" {
  count = local.envoy.enable_nlb ? 1 : 0

  resource_group_name = local.network_name
  loadbalancer_id     = azurerm_lb.envoy_lb[count.index].id
  name                = "EnvoyAddressPool"
}

resource "azurerm_lb_rule" "envoy_lb_rule" {
  count = local.envoy.enable_nlb ? 1 : 0

  resource_group_name            = local.network_name
  loadbalancer_id                = azurerm_lb.envoy_lb[count.index].id
  name                           = "EnvoyLBRule"
  protocol                       = "Tcp"
  frontend_port                  = local.envoy.listen_port
  backend_port                   = 50051
  frontend_ip_configuration_name = "EnvoyLBAddress"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.envoy_lb_pool[count.index].id
  probe_id                       = azurerm_lb_probe.envoy_lb_probe[count.index].id
}

resource "azurerm_lb_rule" "envoy_lb_privileged_rule" {
  count = local.envoy.enable_nlb ? 1 : 0

  resource_group_name            = local.network_name
  loadbalancer_id                = azurerm_lb.envoy_lb[count.index].id
  name                           = "EnvoyLBPrivilegedRule"
  protocol                       = "Tcp"
  frontend_port                  = local.envoy.privileged_listen_port
  backend_port                   = 50052
  frontend_ip_configuration_name = "EnvoyLBAddress"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.envoy_lb_pool[count.index].id
  probe_id                       = azurerm_lb_probe.envoy_lb_privileged_probe[count.index].id
}

resource "azurerm_lb_rule" "envoy_lb_udp_rule" {
  count = local.envoy.enable_nlb ? 1 : 0

  resource_group_name            = local.network_name
  loadbalancer_id                = azurerm_lb.envoy_lb[count.index].id
  name                           = "EnvoyLBUdpRule"
  protocol                       = "Udp"
  frontend_port                  = 123
  backend_port                   = 123
  frontend_ip_configuration_name = "EnvoyLBAddress"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.envoy_lb_pool[count.index].id
}

resource "azurerm_lb_probe" "envoy_lb_probe" {
  count = local.envoy.enable_nlb ? 1 : 0

  resource_group_name = local.network_name
  loadbalancer_id     = azurerm_lb.envoy_lb[count.index].id
  name                = "envoy-running-probe"
  port                = 50051
}

resource "azurerm_lb_probe" "envoy_lb_privileged_probe" {
  count = local.envoy.enable_nlb ? 1 : 0

  resource_group_name = local.network_name
  loadbalancer_id     = azurerm_lb.envoy_lb[count.index].id
  name                = "envoy-running-privileged-probe"
  port                = 50052
}

resource "azurerm_network_interface_backend_address_pool_association" "envoy_lb_association" {
  count = local.envoy.enable_nlb ? local.envoy.resource_count : 0

  network_interface_id    = module.envoy_cluster.network_interface_ids[count.index]
  ip_configuration_name   = "ipconfig${count.index}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.envoy_lb_pool[0].id
}

resource "azurerm_private_dns_a_record" "envoy_lb" {
  count = local.envoy.enable_nlb && local.envoy.nlb_internal ? 1 : 0

  name                = "envoy-lb"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  records = azurerm_lb.envoy_lb[count.index].private_ip_addresses
}

resource "azurerm_private_dns_a_record" "envoy_dns" {
  count = local.envoy.resource_count

  name                = "envoy-${count.index + 1}"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  records = [module.envoy_cluster.network_interface_private_ip[count.index]]
}

resource "azurerm_private_dns_srv_record" "envoy_exporter_dns_srv" {
  count = local.envoy.resource_count > 0 ? 1 : 0

  name                = "_node-exporter._tcp.envoy"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  dynamic "record" {
    for_each = azurerm_private_dns_a_record.envoy_dns.*.name

    content {
      priority = 0
      weight   = 0
      port     = 9100
      target   = "${record.value}.${local.internal_domain}"
    }
  }
}

resource "azurerm_private_dns_srv_record" "envoy_node_exporter_dns_srv" {
  count = local.envoy.resource_count > 0 ? 1 : 0

  name                = "_envoy-exporter._tcp.envoy"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  dynamic "record" {
    for_each = azurerm_private_dns_a_record.envoy_dns.*.name

    content {
      priority = 0
      weight   = 0
      port     = 9001
      target   = "${record.value}.${local.internal_domain}"
    }
  }
}

resource "azurerm_private_dns_srv_record" "envoy_cadvisor_dns_srv" {
  count = local.envoy.resource_count > 0 ? 1 : 0

  name                = "_cadvisor._tcp.envoy"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  dynamic "record" {
    for_each = azurerm_private_dns_a_record.envoy_dns.*.name

    content {
      priority = 0
      weight   = 0
      port     = 18080
      target   = "${record.value}.${local.internal_domain}"
    }
  }
}

resource "azurerm_private_dns_srv_record" "envoy_fluentd_prometheus_dns_srv" {
  count = local.envoy.resource_count > 0 && local.envoy.enable_tdagent ? 1 : 0

  name                = "_fluentd._tcp.envoy"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  dynamic "record" {
    for_each = azurerm_private_dns_a_record.envoy_dns.*.name

    content {
      priority = 0
      weight   = 0
      port     = 24231
      target   = "${record.value}.${local.internal_domain}"
    }
  }
}
