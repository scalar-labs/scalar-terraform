output "blue_scalardl_ids" {
  value       = module.scalardl_blue.id
  description = "The ID of the provisioning step for blue scalardl."
}

output "green_scalardl_ids" {
  value       = module.scalardl_green.id
  description = "The ID of the provisioning step for green scalardl."
}

output "blue_scalardl_ips" {
  value       = module.scalardl_blue.ip
  description = "A list of host IP addresess for the blue scalardl."
}

output "green_scalardl_ips" {
  value       = module.scalardl_green.ip
  description = "A list of host IP addresess for the green scalardl."
}

output "scalardl_security_id" {
  value       = aws_security_group.scalardl.*.id
  description = "The security group ID of the scalardl cluster."
}

output "scalardl_lb_dns" {
  value       = aws_lb.scalardl-lb.*.dns_name
  description = "A list of dns urls to access the scalardl cluster."
}

output "scalardl_blue_resource_count" {
  value       = local.scalardl.blue_resource_count
  description = "The number of resources to create blue scalardl."
}

output "scalardl_green_resource_count" {
  value       = local.scalardl.green_resource_count
  description = "The number of resources to create green scalardl."
}

output "scalardl_replication_factor" {
  value       = local.scalardl.replication_factor
  description = "The replication factor for schema of scalardl."
}
