output "inventory_ini" {
  value = <<EOF
[bastion]
${local.network.bastion_ip}

[bastion:vars]
ansible_user=${local.network.user_name}
ansible_python_interpreter=/usr/bin/python3

[all:vars]
internal_domain=${local.network.internal_domain}
EOF
}

output "kube_config" {
  value       = module.kubernetes.kube_config
  description = "kubectl configuration e.g: ~/.kube/config"
}

output "config_map_aws_auth" {
  value = module.kubernetes.config_map_aws_auth
}
