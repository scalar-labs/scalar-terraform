output "inventory_ini" {
  value = <<EOF
[bookie]
%{for f in aws_route53_record.bookie_dns.*.fqdn~}
${f}
%{endfor}

[broker]
%{for f in aws_route53_record.broker_dns.*.fqdn~}
${f}
%{endfor}

[zookeeper]
%{for f in aws_route53_record.zookeeper_dns.*.fqdn~}
${f}
%{endfor}

[bookie:vars]
host=bookie

[broker:vars]
host=broker

[zookeeper:vars]
host=zookeeper

[all:vars]
zookeeper_servers=${join(",", module.zookeeper_cluster.private_ip)}
broker_server=broker-lb.${local.internal_domain}
internal_domain=${local.internal_domain}
network_name=${local.network_name}
base=${var.base}
cloud_provider=aws
EOF

  description = "The inventory file for Ansible."
}
