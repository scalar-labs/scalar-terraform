module "cassy_cluster" {
  source = "github.com/scalar-labs/terraform-azurerm-compute?ref=upgrade-base-to-2.0.0"

  nb_instances                  = local.cassy.resource_count
  admin_username                = local.user_name
  resource_group_name           = local.network_name
  location                      = local.location
  vm_hostname                   = "cassy"
  nb_public_ip                  = "0"
  vm_os_simple                  = local.image_id
  vnet_subnet_id                = local.subnet_id
  vm_size                       = local.cassy.resource_type
  delete_os_disk_on_termination = true
  ssh_key                       = local.public_key_path
}

module "cassy_provision" {
  source           = "../../universal/cassy"
  triggers         = local.triggers
  bastion_host_ip  = local.bastion_ip
  host_list        = module.cassy_cluster.network_interface_private_ip
  user_name        = local.user_name
  private_key_path = local.private_key_path
  provision_count  = local.cassy.resource_count
  enable_tdagent   = local.cassy.enable_tdagent
}

resource "azurerm_dns_a_record" "cassy-dns" {
  count = local.cassy.resource_count

  name                = "cassy-${count.index + 1}"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  records = [module.cassy_cluster.network_interface_private_ip[count.index]]
}

resource "azurerm_dns_srv_record" "cassy-exporter-dns-srv" {
  count = local.cassy.resource_count > 0 ? 1 : 0

  name                = "_node-exporter._tcp.cassy"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  dynamic record {
    for_each = azurerm_dns_a_record.cassy-dns.*.name

    content {
      priority = 0
      weight   = 0
      port     = 9100
      target   = "${record.value}.internal.scalar-labs.com"
    }
  }
}

resource "azurerm_dns_srv_record" "cassy-dns-srv" {
  count = local.cassy.resource_count > 0 ? 1 : 0

  name                = "_cassy._tcp.cassy"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  dynamic record {
    for_each = azurerm_dns_a_record.cassy-dns.*.name

    content {
      priority = 0
      weight   = 0
      port     = 8081
      target   = "${record.value}.internal.scalar-labs.com"
    }
  }
}

resource "azurerm_dns_srv_record" "cassy-cadvisor-dns-srv" {
  count = local.cassy.resource_count > 0 ? 1 : 0

  name                = "_cadvisor._tcp.cassy"
  zone_name           = local.network_dns
  resource_group_name = local.network_name
  ttl                 = 300

  dynamic record {
    for_each = azurerm_dns_a_record.cassy-dns.*.name

    content {
      priority = 0
      weight   = 0
      port     = 18080
      target   = "${record.value}.internal.scalar-labs.com"
    }
  }
}
