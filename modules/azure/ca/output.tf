output "inventory_ini" {
  value = <<EOF
[ca]
%{for f in azurerm_private_dns_a_record.ca_dns.*.name~}
${f}
%{endfor}
EOF

  description = "The inventory file for Ansible."
}
