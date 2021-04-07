output "cassandra_host_ips" {
  value       = module.cassandra_cluster.network_interface_private_ip
  description = "A list of host IP addresess for the Cassandra cluster."
}

output "cassandra_seed_ips" {
  value       = local.cassandra.resource_count > 0 ? slice(module.cassandra_cluster.network_interface_private_ip, 0, min(local.cassandra.resource_count, 3)) : []
  description = "A list of host IP addresess for the Cassandra seeds."
}

output "cassandra_host_ids" {
  value       = module.cassandra_cluster.vm_ids
  description = "A list of host IDs for the Cassandra cluster."
}

output "network_interface_ids" {
  value       = module.cassandra_cluster.network_interface_ids
  description = "A list of network interface IDs for the Cassandra cluster."
}

output "cassandra_resource_count" {
  value       = local.cassandra.resource_count
  description = "The number of Cassandra nodes to create."
}

output "inventory_ini" {
  value       = local.inventory
  description = "The inventory file for Ansible."
}
