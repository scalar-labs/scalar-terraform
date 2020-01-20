output "network_interface_private_ip" {
  value = module.cluster.network_interface_private_ip
}

output "network_interface_ids" {
  value = module.cluster.network_interface_ids
}

output "vm_ids" {
  value = module.cluster.vm_ids
}
