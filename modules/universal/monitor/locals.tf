locals {
  scalardl_targets  = contains(var.targets, "scalardl") ? ["scalardl-blue", "scalardl-green", "envoy"] : []
  cassandra_targets = contains(var.targets, "cassandra") ? ["cassandra", "cassy", "reaper"] : []
  monitor_targets   = ["grafana", "alertmanager", "prometheus", "nginx"]

  service_targets   = setunion(local.scalardl_targets, local.cassandra_targets)
  node_targets      = setunion(local.service_targets, ["bastion", "monitor"])
  cadvisor_targets  = setunion(local.service_targets, ["monitor"])
}
