output "inventory_ini" {
  value = <<EOF
[monitor]
%{for ip in aws_route53_record.monitor_host_dns.*.fqdn~}
${ip}
%{endfor}

[all:vars]
internal_domain=${local.internal_domain}
monitor_host=monit.${local.internal_domain}
EOF
}
