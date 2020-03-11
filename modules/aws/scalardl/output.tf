output "blue_scalardl_ids" {
  value       = module.scalardl_blue.id
  description = "A list of host IDs for blue cluster."
}

output "green_scalardl_ids" {
  value       = module.scalardl_green.id
  description = "A list of host IDs for green cluster."
}

output "blue_scalardl_ips" {
  value       = module.scalardl_blue.ip
  description = "A list of host IP addresess for blue cluster."
}

output "green_scalardl_ips" {
  value       = module.scalardl_green.ip
  description = "A list of host IP addresess for green cluster."
}

output "scalardl_security_id" {
  value       = aws_security_group.scalardl.*.id
  description = "The security group ID of a scalardl cluster."
}

output "scalardl_lb_dns" {
  value       = aws_lb.scalardl-lb.*.dns_name
  description = "A list of dns URLs to access a scalardl cluster."
}

output "scalardl_lb_listen_port" {
  value       = local.scalardl.listen_port
  description = "A listen port of an scalardl cluster."
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
  value       = aws_lb.envoy-lb.*.dns_name
  description = "A list of DNS URLs to access an envoy cluster."
}

output "envoy_listen_port" {
  value       = local.envoy.listen_port
  description = "A listen port of an envoy cluster."
}
