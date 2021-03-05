resource "local_file" "inventory" {
  content         = local.inventory
  filename        = "pulsar_inventory"
  file_permission = "0644"
}
