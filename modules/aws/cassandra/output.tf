output "cassandra_provision_ids" {
  value       = module.cassandra_provision.provision_ids
  description = "The IDs of the provisioning step."
}

output "cassandra_host_ips" {
  value       = module.cassandra_cluster.private_ip
  description = "A list of host IP addresess for the cassandra cluster."
}

output "cassandra_seed_ips" {
  value       = local.cassandra.resource_count > 0 ? slice(module.cassandra_cluster.private_ip, 0, min(local.cassandra.resource_count, 3)) : []
  description = "A list of host IP addresess for the cassandra seeds."
}

output "cassandra_host_ids" {
  value       = module.cassandra_cluster.id
  description = "A list of host IDs for the cassandra cluster."
}

output "cassandra_security_ids" {
  value       = aws_security_group.cassandra.*.id
  description = "The security group IDs of the cassandra cluster."
}

output "cassandra_hosts" {
  value       = aws_route53_record.cassandra-dns.*.name
  description = "A list of dns urls to access the cassandra cluster."
}

output "network_interface_ids" {
  value = module.cassandra_cluster.primary_network_interface_id
  description = "A list of primary interface ID for the cassandra cluster."
}

output "cassandra_resource_count" {
  value       = local.cassandra.resource_count
  description = "The number of cassandra nodes to create."
}

output "cassandra_start_on_initial_boot" {
  value       = local.cassandra.start_on_initial_boot
  description = "A flag to start cassandra or not on the initial boot."
}
