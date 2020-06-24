output "provision_ids" {
  value = null_resource.pulsar.*.id
}
