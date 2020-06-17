locals {
  scalardl_targets  = contains(var.target_monitoring, "scalardl") ? ["scalardl-blue", "scalardl-green", "envoy"] : []
  cassandra_targets = contains(var.target_monitoring, "cassandra") ? ["cassandra", "cassy", "reaper"] : []
  general_targets   = ["grafana", "alertmanager", "prometheus", "nginx"]

  service_targets   = setunion(local.scalardl_targets, local.cassandra_targets)
  node_targets      = setunion(local.service_targets, ["bastion", "monitor"])
  cadvisor_targets  = setunion(local.service_targets, ["monitor"])
}
