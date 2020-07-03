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
EOF
}
