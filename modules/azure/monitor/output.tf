output "inventory_ini" {
  value = <<EOF
[monitor]
%{for f in azurerm_private_dns_a_record.monitor_host_dns.*.fqdn~}
${f}
%{endfor}
EOF

  description = "The inventory file for Ansible."
}
