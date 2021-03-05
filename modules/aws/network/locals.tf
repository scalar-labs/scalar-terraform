### default
locals {
  network_default = {
    bastion_resource_type     = "t3.micro"
    bastion_resource_count    = 2
    bastion_access_cidr       = "0.0.0.0/0"
    resource_root_volume_size = 16
    bastion_enable_tdagent    = true
    user_name                 = "centos"
    cidr                      = "10.42.0.0/16"
  }
}

locals {
  network_base = {
    default = local.network_default

    bai = merge(local.network_default, {})

    chiku = merge(local.network_default, {})

    sho = merge(local.network_default, {})
  }
}

locals {
  network = merge(
    local.network_base[var.base],
    var.network
  )
}

locals {
  dist_locations = distinct(var.locations)

  locations = length(local.dist_locations) == 2 ? concat(local.dist_locations, [local.dist_locations[0]]) : local.dist_locations

  subnet_map = {
    public         = cidrsubnets(cidrsubnet(local.network.cidr, 8, 0), 2, 2, 2)
    private        = cidrsubnets(cidrsubnet(local.network.cidr, 8, 1), 2, 2, 2)
    cassandra      = cidrsubnets(cidrsubnet(local.network.cidr, 8, 2), 2, 2, 2)
    scalardl_blue  = cidrsubnets(cidrsubnet(local.network.cidr, 8, 3), 2, 2, 2)
    scalardl_green = cidrsubnets(cidrsubnet(local.network.cidr, 8, 4), 2, 2, 2)
    pulsar         = cidrsubnets(cidrsubnet(local.network.cidr, 8, 5), 2, 2, 2)
    kubernetes     = cidrsubnets(cidrsubnet(local.network.cidr, 6, 10), 2, 2, 2)
  }
}

locals {
  ssh_config = <<EOF
Host *
User ${local.network.user_name}
UserKnownHostsFile /dev/null
StrictHostKeyChecking no

Host bastion
HostName ${module.bastion.bastion_host_ips[0]}
LocalForward 8000 monitor.${var.internal_domain}:80

Host *.${var.internal_domain}
ProxyCommand ssh -F ssh.cfg bastion -W %h:%p
EOF

  inventory = <<EOF
[bastion]
%{for f in module.bastion.bastion_host_ips~}
${f}
%{endfor}

[bastion:vars]
host=bastion

[all:vars]
internal_domain=${var.internal_domain}
base=${var.base}
cloud_provider=aws
ansible_user=${local.network.user_name}
ansible_python_interpreter=/usr/bin/python3
EOF
}
