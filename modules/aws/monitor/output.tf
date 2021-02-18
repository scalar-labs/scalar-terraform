output "inventory_ini" {
  value = <<EOF
[monitor]
%{for f in aws_route53_record.monitor_host_dns.*.fqdn~}
${f}
%{endfor}

[monitor:vars]
host=monitor

[all:vars]
base=${var.base}
cloud_provider=aws
EOF

  description = "The inventory file for Ansible."
}
