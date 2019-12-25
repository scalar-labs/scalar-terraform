output "blue_scalardl_ids" {
  value = module.scalardl_blue.id
}

output "green_scalardl_ids" {
  value = module.scalardl_green.id
}

output "blue_scalardl_ips" {
  value = module.scalardl_blue.ip
}

output "green_scalardl_ips" {
  value = module.scalardl_green.ip
}

output "scalardl_security_id" {
  value = aws_security_group.scalardl.id
}

output "scalardl_lb_dns" {
  value = aws_lb.scalardl-lb.*.dns_name
}

output "scalardl_lb_arn" {
  value = element(aws_lb.scalardl-lb.*.arn, 0)
}

output "scalardl_blue_resource_count" {
  value = local.blue_resource_count
}

output "scalardl_green_resource_count" {
  value = local.green_resource_count
}

output "scalardl_replication_factor" {
  value = local.replication_factor
}
