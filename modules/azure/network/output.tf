output "network_id" {
  value = azurerm_virtual_network.vnet.id
}

output "network_name" {
  value = module.name_generator.name
}

output "cidr" {
  value = azurerm_virtual_network.vnet.address_space[0]
}

output "subnet_map" {
  value = {
    public    = azurerm_subnet.subnet.*.id[0]
    private   = azurerm_subnet.subnet.*.id[1]
    cassandra = azurerm_subnet.subnet.*.id[2]
    blue      = azurerm_subnet.subnet.*.id[3]
    green     = azurerm_subnet.subnet.*.id[4]
  }
}

output "dns_zone_id" {
  value = basename(azurerm_dns_zone.dns.id)
}
