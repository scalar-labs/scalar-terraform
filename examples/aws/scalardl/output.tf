output "scalardl_blue_resource_count" {
  value = module.scalardl.scalardl_blue_resource_count
}

output "scalardl_green_resource_count" {
  value = module.scalardl.scalardl_green_resource_count
}

output "scalardl_replication_factor" {
  value = module.scalardl.scalardl_replication_factor
}

output "envoy_dns" {
  value = module.scalardl.*.envoy_dns
}

output "envoy_listen_port" {
  value = local.envoy.listen_port
}

output "scalardl_dns" {
  value = module.scalardl.*.scalardl_lb_dns
}

output "scalardl_listen_port" {
  value = local.scalardl.listen_port
}
