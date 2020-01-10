output "id" {
  value       = module.scalardl_cluster.id
  description = "List of IDs of scalardl cluster."
}

output "ip" {
  value       = module.scalardl_cluster.private_ip
  description = "List of private IP addresses assigned to the scalardl cluster instances."
}
