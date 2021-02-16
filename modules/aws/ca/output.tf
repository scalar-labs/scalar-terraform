output "inventory_ini" {
  value = <<EOF
[ca]
%{for f in aws_route53_record.ca_dns.*.fqdn~}
${f}
%{endfor}
EOF

  description = "The inventory file for Ansible."
}
