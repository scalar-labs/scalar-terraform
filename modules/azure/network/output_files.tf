resource "local_file" "ssh_config" {
  content              = local.ssh_config
  filename             = "ssh.cfg"
  file_permission      = "0644"
  directory_permission = "0755"
}

resource "local_file" "inventory" {
  content              = local.inventory
  filename             = "network_inventory"
  file_permission      = "0644"
  directory_permission = "0755"
}
