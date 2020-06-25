output "provision_ids" {
  value = null_resource.bookie.*.id
}
