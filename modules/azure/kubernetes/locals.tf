# General network
locals {
  network_name    = var.network.name
  network_cidr    = var.network.cidr
  network_id      = var.network.id
  public_key_path = var.network.public_key_path
  locations       = compact(split(",", var.network.locations))
}

# Network subnet
locals {
  kubernetes_cluster_network = {
    k8s_node_pod = {
      address_prefixes  = [cidrsubnet(local.network_cidr, 6, 10)]
      service_endpoints = var.use_cosmosdb ? ["Microsoft.AzureCosmosDB"] : []
    }
    k8s_ingress = {
      address_prefixes = [cidrsubnet(local.network_cidr, 6, 11)]
    }
  }
}

# Default k8s global
locals {
  kubernetes_cluster_default = {
    name                      = "scalar-kubernetes"
    resource_group_name       = var.network.name
    region                    = var.network.region
    dns_prefix                = "scalar-kubernetes"
    kubernetes_version        = "1.16.13"
    admin_username            = "azureuser"
    public_ssh_key_path       = var.network.public_key_path
    role_based_access_control = true
    kube_dashboard            = true
    public_cluster_enabled    = false
    network_plugin            = "azure"
    load_balancer_sku         = "Standard"
    service_cidr              = cidrsubnet(var.network.cidr, 6, 12)
    docker_bridge_cidr        = "172.17.0.1/16"
    dns_service_ip            = cidrhost(cidrsubnet(var.network.cidr, 6, 12), 2)
  }
}

## Merge k8s global with user input
locals {
  kubernetes_cluster = merge(
    local.kubernetes_cluster_default,
    var.kubernetes_cluster
  )
}

# K8s default node pool
locals {
  kubernetes_node_pool = {
    name                           = "default"
    node_count                     = 3
    vm_size                        = "Standard_D2s_v3"
    max_pods                       = 10
    os_disk_size_gb                = 64
    cluster_auto_scaling           = false
    cluster_auto_scaling_min_count = 3
    cluster_auto_scaling_max_count = 6
  }
}

## Merge k8s default node pool with user input
locals {
  kubernetes_default_node_pool = merge(
    local.kubernetes_node_pool,
    var.kubernetes_default_node_pool
  )
}

# K8s scalar apps node pool
locals {
  scalar_apps_pool = {
    name                           = "scalardlpool"
    node_count                     = 3
    vm_size                        = "Standard_D2s_v3"
    max_pods                       = 10
    os_disk_size_gb                = 64
    node_os                        = "Linux"
    taints                         = "kubernetes.io/app=scalardlpool:NoSchedule"
    cluster_auto_scaling           = false
    cluster_auto_scaling_min_count = 3
    cluster_auto_scaling_max_count = 6
  }
}

## Merge k8s additional node pools (scalardl dedicated)
locals {
  kubernetes_scalar_apps_pool = merge(
    local.scalar_apps_pool,
    var.kubernetes_scalar_apps_pool
  )
}

locals {
  kubeconfig = azurerm_kubernetes_cluster.aks_cluster.kube_config_raw

  k8s_ssh_config = <<EOF
Host *
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no

Host bastion
  HostName ${var.network.bastion_ip}
  User ${var.network.user_name}
  LocalForward 8000 monitor.${var.network.internal_domain}:80
  LocalForward 7000 ${replace(azurerm_kubernetes_cluster.aks_cluster.kube_config.0.host, "https://", "")}

Host *.${var.network.internal_domain}
  User ${var.network.user_name}
  ProxyCommand ssh -F ssh.cfg bastion -W %h:%p

Host ${regex("(^10\\.|^172\\.1[6-9]\\.|^172\\.2[0-9]\\.|^172\\.3[0-1]\\.|^192\\.168\\.)", var.network.cidr)[0]}*
  User ${local.kubernetes_cluster.admin_username}
  ProxyCommand ssh -F k8s_ssh.cfg bastion -W %h:%p
EOF
}
