output "inventory_ini" {
  value = <<EOF
[ca]
%{for f in azurerm_private_dns_a_record.ca_dns.*.name~}
${f}.${local.internal_domain}
%{endfor}

[ca:vars]
host=ca

[all:vars]
cloud_provider=azure
EOF

  description = "The inventory file for Ansible."
}
