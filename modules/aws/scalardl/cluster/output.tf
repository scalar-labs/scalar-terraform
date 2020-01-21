output "id" {
  value       = module.scalardl_cluster.id
  description = "A list of IDs of a scalardl cluster."
}

output "ip" {
  value       = module.scalardl_cluster.private_ip
  description = "A list of private IP addresses assigned to scalardl cluster instances."
}
