module "reaper_cluster" {
  source = "github.com/scalar-labs/terraform-azurerm-compute?ref=ca8c721"

  nb_instances                  = local.reaper.resource_count
  admin_username                = local.user_name
  resource_group_name           = local.network_name
  location                      = local.location
  vm_hostname                   = "reaper"
  nb_public_ip                  = "0"
  vm_os_simple                  = local.image_id
  vnet_subnet_id                = local.subnet_id
  vm_size                       = local.reaper.resource_type
  delete_os_disk_on_termination = true
  ssh_key                       = local.public_key_path
}

module "reaper_provision" {
  source = "../../universal/reaper"

  triggers           = local.triggers
  bastion_host_ip    = local.bastion_ip
  host_list          = module.reaper_cluster.network_interface_private_ip
  user_name          = local.user_name
  private_key_path   = local.private_key_path
  provision_count    = local.reaper.resource_count
  replication_factor = local.reaper.replication_factor
  enable_tdagent     = local.reaper.enable_tdagent
  internal_domain    = local.internal_domain
}

resource "azurerm_private_dns_a_record" "reaper-dns" {
  count = local.reaper.resource_count

  name                = "reaper-${count.index + 1}"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  records = [module.reaper_cluster.network_interface_private_ip[count.index]]
}

resource "azurerm_private_dns_srv_record" "reaper-exporter-dns-srv" {
  count = local.reaper.resource_count > 0 ? 1 : 0

  name                = "_node-exporter._tcp.reaper"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  dynamic record {
    for_each = azurerm_private_dns_a_record.reaper-dns.*.name

    content {
      priority = 0
      weight   = 0
      port     = 9100
      target   = "${record.value}.${local.internal_domain}"
    }
  }
}

resource "azurerm_private_dns_srv_record" "reaper-dns-srv" {
  count = local.reaper.resource_count > 0 ? 1 : 0

  name                = "_reaper._tcp.reaper"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  dynamic record {
    for_each = azurerm_private_dns_a_record.reaper-dns.*.name

    content {
      priority = 0
      weight   = 0
      port     = 8081
      target   = "${record.value}.${local.internal_domain}"
    }
  }
}

resource "azurerm_private_dns_srv_record" "reaper-cadvisor-dns-srv" {
  count = local.reaper.resource_count > 0 ? 1 : 0

  name                = "_cadvisor._tcp.reaper"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  dynamic record {
    for_each = azurerm_private_dns_a_record.reaper-dns.*.name

    content {
      priority = 0
      weight   = 0
      port     = 18080
      target   = "${record.value}.${local.internal_domain}"
    }
  }
}
