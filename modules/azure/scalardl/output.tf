output "blue_scalardl_ids" {
  value = module.scalardl_blue.vm_ids
}

output "green_scalardl_ids" {
  value = module.scalardl_green.vm_ids
}

output "blue_scalardl_ips" {
  value = module.scalardl_blue.network_interface_private_ip
}

output "green_scalardl_ips" {
  value = module.scalardl_green.network_interface_private_ip
}

output "availability_set_id" {
  value = azurerm_availability_set.scalar_availability_set.id
}

output "scalardl_lb_dns" {
  value = azurerm_private_dns_a_record.scalar-dns-lb.*.name
}

output "scalardl_lb_id" {
  value = azurerm_lb.scalardl-lb.*.id
}

output "scalardl_blue_resource_count" {
  value = local.scalardl.blue_resource_count
}

output "scalardl_green_resource_count" {
  value = local.scalardl.green_resource_count
}

output "scalardl_replication_factor" {
  value = local.scalardl.replication_factor
}

output "envoy_dns" {
  value = local.envoy.resource_count > 0 ? azurerm_public_ip.envoy-public-ip.*.fqdn : []
}

output "envoy_listen_port" {
  value = local.envoy.listen_port
}
