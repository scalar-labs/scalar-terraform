resource "local_file" "inventory" {
  content         = local.inventory
  filename        = "cassandra_inventory"
  file_permission = "0644"
}
