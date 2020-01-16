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
  value = local.subnet
}

output "dns_zone_id" {
  value = basename(azurerm_private_dns_zone.dns.id)
}
