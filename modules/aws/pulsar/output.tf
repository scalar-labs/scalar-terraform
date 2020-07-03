output "inventory_ini" {
  value = <<EOF
[bookie]
%{for ip in module.bookie_cluster.private_ip~}
${ip}
%{endfor}

[broker]
%{for ip in module.broker_cluster.private_ip~}
${ip}
%{endfor}

[zookeeper]
%{for ip in module.zookeeper_cluster.private_ip~}
${ip}
%{endfor}
EOF
}
