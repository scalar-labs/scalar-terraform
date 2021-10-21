module "cassy_cluster" {
  source = "github.com/scalar-labs/terraform-azurerm-compute?ref=2d31780"

  nb_instances                  = local.cassy.resource_count
  admin_username                = local.user_name
  resource_group_name           = local.network_name
  location                      = local.region
  availability_zones            = local.locations
  vm_hostname                   = "cassy"
  nb_public_ip                  = "0"
  vm_os_simple                  = local.image_id
  vm_os_publisher               = local.vm_os_publisher
  vm_os_offer                   = local.vm_os_offer
  vm_os_sku                     = local.vm_os_sku
  vnet_subnet_id                = local.subnet_id
  vm_size                       = local.cassy.resource_type
  delete_os_disk_on_termination = true
  ssh_key                       = local.public_key_path
  enable_accelerated_networking = local.cassy.enable_accelerated_networking
}

module "cassy_provision" {
  source = "../../universal/cassy"

  vm_ids           = module.cassy_cluster.vm_ids
  triggers         = local.triggers
  bastion_host_ip  = local.bastion_ip
  host_list        = module.cassy_cluster.network_interface_private_ip
  user_name        = local.user_name
  private_key_path = local.private_key_path
  provision_count  = local.cassy.resource_count
  enable_tdagent   = local.cassy.enable_tdagent
  internal_domain  = local.internal_domain
  image_tag        = local.cassy.image_tag
  storage_base_uri = local.cassy.storage_base_uri
  storage_type     = local.cassy.storage_type
}

resource "azurerm_private_dns_a_record" "cassy_dns" {
  count = local.cassy.resource_count

  name                = "cassy-${count.index + 1}"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  records = [module.cassy_cluster.network_interface_private_ip[count.index]]
}

resource "azurerm_private_dns_srv_record" "cassy_exporter_dns_srv" {
  count = local.cassy.resource_count > 0 ? 1 : 0

  name                = "_node-exporter._tcp.cassy"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  dynamic "record" {
    for_each = azurerm_private_dns_a_record.cassy_dns.*.name

    content {
      priority = 0
      weight   = 0
      port     = 9100
      target   = "${record.value}.${local.internal_domain}"
    }
  }
}

resource "azurerm_private_dns_srv_record" "cassy_dns_srv" {
  count = local.cassy.resource_count > 0 ? 1 : 0

  name                = "_cassy._tcp.cassy"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  dynamic "record" {
    for_each = azurerm_private_dns_a_record.cassy_dns.*.name

    content {
      priority = 0
      weight   = 0
      port     = 8081
      target   = "${record.value}.${local.internal_domain}"
    }
  }
}

resource "azurerm_private_dns_srv_record" "cassy_cadvisor_dns_srv" {
  count = local.cassy.resource_count > 0 ? 1 : 0

  name                = "_cadvisor._tcp.cassy"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  dynamic "record" {
    for_each = azurerm_private_dns_a_record.cassy_dns.*.name

    content {
      priority = 0
      weight   = 0
      port     = 18080
      target   = "${record.value}.${local.internal_domain}"
    }
  }
}

resource "azurerm_private_dns_srv_record" "cassy_fluentd_prometheus_dns_srv" {
  count = local.cassy.resource_count > 0 && local.cassy.enable_tdagent ? 1 : 0

  name                = "_fluentd._tcp.cassy"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  dynamic "record" {
    for_each = azurerm_private_dns_a_record.cassy_dns.*.name

    content {
      priority = 0
      weight   = 0
      port     = 24231
      target   = "${record.value}.${local.internal_domain}"
    }
  }
}
