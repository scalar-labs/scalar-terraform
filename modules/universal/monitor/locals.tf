locals {
  scalardl_targets      = contains(var.targets, "scalardl") ? ["scalardl-blue", "scalardl-green", "envoy"] : []
  cassandra_gen_targets = contains(var.targets, "cassandra") ? ["cassandra"] : []
  cassandra_ops_targets = contains(var.targets, "cassandra") ? ["cassy", "reaper"] : []
  monitor_targets       = ["grafana", "alertmanager", "prometheus", "nginx"]

  service_targets  = setunion(local.scalardl_targets, local.cassandra_gen_targets, local.cassandra_ops_targets)
  node_targets     = setunion(local.service_targets, ["bastion", "monitor"])
  cadvisor_targets = setunion(local.scalardl_targets, local.cassandra_ops_targets, ["monitor"])
}
