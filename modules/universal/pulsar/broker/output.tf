output "provision_ids" {
  value = null_resource.broker.*.id
}
