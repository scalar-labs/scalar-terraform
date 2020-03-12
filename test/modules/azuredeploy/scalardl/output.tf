output "scalardl_blue_resource_count" {
  value = module.scalardl.scalardl_blue_resource_count
}

output "scalardl_green_resource_count" {
  value = module.scalardl.scalardl_green_resource_count
}

output "scalardl_replication_factor" {
  value = module.scalardl.scalardl_replication_factor
}

output "scalar_dns" {
  value = module.scalardl.envoy_dns[0]
}

output "monitor_url" {
  value = "http://${module.scalardl.envoy_dns[0]}:${module.scalardl.envoy_listen_port}"
}

output "scalardl_blue_test_ip_0" {
  value = module.scalardl.blue_scalardl_ips[0]
}

output "scalardl_blue_test_ip_1" {
  value = module.scalardl.blue_scalardl_ips[1]
}
