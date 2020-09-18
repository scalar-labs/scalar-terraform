### General
locals {
  network_name        = var.network.name
  region              = var.network.region
  node_pool_subnet_id = var.kubernetes.node_pool_subnet_id
}
