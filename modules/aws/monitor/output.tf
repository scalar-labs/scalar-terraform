output "inventory_ini" {
  value = <<EOF
[monitor]
%{for f in aws_route53_record.monitor_host_dns.*.fqdn~}
${f}
%{endfor}
EOF

  description = "The inventory file for Ansible."
}
