resource "local_file" "inventory" {
  content         = local.inventory
  filename        = "scalardl_inventory"
  file_permission = "0644"
}
