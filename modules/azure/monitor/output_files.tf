resource "local_file" "inventory" {
  content              = local.inventory
  filename             = "monitor_inventory"
  file_permission      = "0644"
  directory_permission = "0755"
}
