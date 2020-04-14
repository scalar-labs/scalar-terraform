
output "public_key" {
  value = tls_private_key.cassy_private_key.public_key_openssh
}

output "storage_base_uri" {
  value = var.storage_base_uri
}
