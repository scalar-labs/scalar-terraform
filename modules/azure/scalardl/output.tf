output "blue_scalardl_ids" {
  value       = module.scalardl_blue.vm_ids
  description = "A list of host IDs for blue cluster."
}

output "green_scalardl_ids" {
  value       = module.scalardl_green.vm_ids
  description = "A list of host IDs for green cluster."
}

output "blue_scalardl_ips" {
  value       = module.scalardl_blue.network_interface_private_ip
  description = "A list of host IP addresess for blue cluster."
}

output "green_scalardl_ips" {
  value       = module.scalardl_green.network_interface_private_ip
  description = "A list of host IP addresess for green cluster."
}

output "availability_set_id" {
  value       = azurerm_availability_set.scalar_availability_set.id
  description = "The virtual Availability Set ID."
}

output "scalardl_blue_resource_count" {
  value       = local.scalardl.blue_resource_count
  description = "The number of resources to create for blue cluster."
}

output "scalardl_green_resource_count" {
  value       = local.scalardl.green_resource_count
  description = "The number of resources to create for green cluster."
}

output "scalardl_replication_factor" {
  value       = local.scalardl.replication_factor
  description = "The replication factor for the schema of scalardl."
}

output "envoy_dns" {
  value       = local.envoy.enable_nlb ? (local.envoy.nlb_internal ? ["envoy-lb.${local.internal_domain}"] : azurerm_public_ip.envoy_public_ip.*.fqdn) : []
  description = "A list of dns URLs to access a envoy cluster."
}

output "envoy_listen_port" {
  value       = local.envoy.listen_port
  description = "A listen port of envoy cluster."
}

output "envoy_host_ips" {
  value       = module.envoy_cluster.network_interface_private_ip
  description = "A list of host IPs for envoy cluster."
}
