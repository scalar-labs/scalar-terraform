output "inventory_ini" {
  value = <<EOF
[ca]
%{for f in aws_route53_record.ca_dns.*.fqdn~}
${f}
%{endfor}

[ca:vars]
host=ca

[all:vars]
cloud_provider=aws
EOF

  description = "The inventory file for Ansible."
}
