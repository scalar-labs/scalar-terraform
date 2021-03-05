### default
locals {
  network_default = {
    bastion_resource_type                 = "Standard_B1s"
    bastion_resource_count                = 1
    bastion_access_cidr                   = "0.0.0.0/0"
    bastion_resource_root_volume_size     = 32
    bastion_enable_tdagent                = true
    bastion_enable_accelerated_networking = false
    user_name                             = "centos"
    cidr                                  = "10.42.0.0/16"
    image_id                              = "CentOS"
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
  subnet = {
    public = {
      address_prefix    = cidrsubnet(local.network.cidr, 8, 0)
      service_endpoints = []
    }
    private = {
      address_prefix    = cidrsubnet(local.network.cidr, 8, 1)
      service_endpoints = []
    }
    cassandra = {
      address_prefix    = cidrsubnet(local.network.cidr, 8, 2)
      service_endpoints = []
    }
    scalardl_blue = {
      address_prefix    = cidrsubnet(local.network.cidr, 8, 3)
      service_endpoints = var.use_cosmosdb ? ["Microsoft.AzureCosmosDB"] : []
    }
    scalardl_green = {
      address_prefix    = cidrsubnet(local.network.cidr, 8, 4)
      service_endpoints = var.use_cosmosdb ? ["Microsoft.AzureCosmosDB"] : []
    }
  }

  locations = compact(var.locations)
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
cloud_provider=azure
ansible_user=${local.network.user_name}
ansible_python_interpreter=/usr/bin/python3
EOF
}
