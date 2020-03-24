resource "null_resource" "envoy_wait_for" {
  triggers = {
    network_id = local.network_id
  }
}

module "envoy_cluster" {
  source = "github.com/scalar-labs/terraform-azurerm-compute?ref=ca8c721"

  nb_instances                  = local.envoy.resource_count
  admin_username                = local.user_name
  resource_group_name           = local.network_name
  location                      = local.location
  vm_hostname                   = "envoy"
  nb_public_ip                  = "0"
  vm_os_simple                  = local.image_id
  vnet_subnet_id                = local.envoy.subnet_id
  vm_size                       = local.envoy.resource_type
  ssh_key                       = local.public_key_path
  storage_os_disk_size          = local.envoy.resource_root_volume_size
  delete_os_disk_on_termination = true
  remote_port                   = local.envoy.target_port
}

module "envoy_provision" {
  source = "../../universal/envoy"

  triggers            = local.triggers
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
  envoy_port          = local.envoy.target_port
  enable_tdagent      = local.envoy.enable_tdagent
  custom_config_path  = local.envoy.custom_config_path
  internal_root_dns   = local.internal_root_dns
}

resource "azurerm_public_ip" "envoy-public-ip" {
  count      = local.envoy.resource_count > 0 ? 1 : 0
  depends_on = [null_resource.envoy_wait_for]

  name                = "PublicIPForEnvoy"
  domain_name_label   = "envoy-${local.network_name}"
  location            = local.location
  resource_group_name = local.network_name
  allocation_method   = "Static"
}

resource "azurerm_lb" "envoy-lb" {
  count = local.envoy.resource_count > 0 ? 1 : 0

  name                = "EnvoyLoadBalancer"
  location            = local.location
  resource_group_name = local.network_name

  frontend_ip_configuration {
    name                 = "EnvoyLBAddress"
    public_ip_address_id = azurerm_public_ip.envoy-public-ip.*.id[count.index]
  }
}

resource "azurerm_lb_backend_address_pool" "envoy-lb-pool" {
  count = local.envoy.resource_count > 0 ? 1 : 0

  resource_group_name = local.network_name
  loadbalancer_id     = azurerm_lb.envoy-lb.*.id[count.index]
  name                = "EnvoyAddressPool"
}

resource "azurerm_lb_rule" "envoy-lb-rule" {
  count = local.envoy.resource_count > 0 ? 1 : 0

  resource_group_name            = local.network_name
  loadbalancer_id                = azurerm_lb.envoy-lb.*.id[count.index]
  name                           = "EnvoyLBRule"
  protocol                       = "Tcp"
  frontend_port                  = local.envoy.listen_port
  backend_port                   = local.envoy.target_port
  frontend_ip_configuration_name = "EnvoyLBAddress"
  backend_address_pool_id        = azurerm_lb_backend_address_pool.envoy-lb-pool.*.id[count.index]
  probe_id                       = azurerm_lb_probe.envoy-lb-probe.*.id[count.index]
}

resource "azurerm_lb_probe" "envoy-lb-probe" {
  count = local.envoy.resource_count > 0 ? 1 : 0

  resource_group_name = local.network_name
  loadbalancer_id     = azurerm_lb.envoy-lb.*.id[count.index]
  name                = "envoy-running-probe"
  port                = local.envoy.target_port
}

resource "azurerm_network_interface_backend_address_pool_association" "envoy-lb-association" {
  count = local.envoy.resource_count

  network_interface_id    = module.envoy_cluster.network_interface_ids[count.index]
  ip_configuration_name   = "ipconfig${count.index}"
  backend_address_pool_id = azurerm_lb_backend_address_pool.envoy-lb-pool.*.id[0]
}

resource "azurerm_private_dns_a_record" "envoy-dns" {
  count = local.envoy.resource_count

  name                = "envoy-${count.index + 1}"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  records = [module.envoy_cluster.network_interface_private_ip[count.index]]
}

resource "azurerm_private_dns_srv_record" "envoy-exporter-dns-srv" {
  count = local.envoy.resource_count > 0 ? 1 : 0

  name                = "_node-exporter._tcp.envoy"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  dynamic record {
    for_each = azurerm_private_dns_a_record.envoy-dns.*.name

    content {
      priority = 0
      weight   = 0
      port     = 9100
      target   = "${record.value}.${local.internal_root_dns}"
    }
  }
}

resource "azurerm_private_dns_srv_record" "envoy-node-exporter-dns-srv" {
  count = local.envoy.resource_count > 0 ? 1 : 0

  name                = "_envoy-exporter._tcp.envoy"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  dynamic record {
    for_each = azurerm_private_dns_a_record.envoy-dns.*.name

    content {
      priority = 0
      weight   = 0
      port     = 9001
      target   = "${record.value}.${local.internal_root_dns}"
    }
  }
}

resource "azurerm_private_dns_srv_record" "envoy-cadvisor-dns-srv" {
  count = local.envoy.resource_count > 0 ? 1 : 0

  name                = "_cadvisor._tcp.envoy"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  dynamic record {
    for_each = azurerm_private_dns_a_record.envoy-dns.*.name

    content {
      priority = 0
      weight   = 0
      port     = 18080
      target   = "${record.value}.${local.internal_root_dns}"
    }
  }
}
