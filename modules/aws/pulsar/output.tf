output "inventory_ini" {
  value = <<EOF
[bookie]
%{for ip in aws_route53_record.bookie_dns.*.fqdn~}
${ip}
%{endfor}

[broker]
%{for ip in aws_route53_record.broker_dns.*.fqdn~}
${ip}
%{endfor}

[zookeeper]
%{for ip in aws_route53_record.zookeeper_dns.*.fqdn~}
${ip}
%{endfor}

[all:vars]
zookeeper_servers=${join(",", module.zookeeper_cluster.private_ip)}
broker_server=broker-lb.${local.internal_domain}
internal_domain=${local.internal_domain}
EOF
}
