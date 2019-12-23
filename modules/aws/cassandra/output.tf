output "cassandra_provision_id" {
  value = module.cassandra_provision.provision_id
}

output "cassandra_host_ips" {
  value = module.cassandra_cluster.private_ip
}

output "cassandra_seed_ips" {
  value = local.resource_count > 0 ? slice(module.cassandra_cluster.private_ip, 0, min(local.resource_count, 3)) : []
}

output "cassandra_host_ids" {
  value = module.cassandra_cluster.id
}

output "cassandra_security_id" {
  value = aws_security_group.cassandra.id
}

output "cassandra_hosts" {
  value = aws_route53_record.cassandra-dns.*.name
}

output "network_interface_ids" {
  value = module.cassandra_cluster.primary_network_interface_id
}

output "cassandra_resource_count" {
  value = local.resource_count
}
