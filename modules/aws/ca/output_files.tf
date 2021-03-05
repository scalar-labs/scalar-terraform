resource "local_file" "inventory" {
  content         = local.inventory
  filename        = "ca_inventory"
  file_permission = "0644"
}
