locals {
  configmap_roles = [
    for arn in concat(
      [aws_iam_role.eks_cluster.arn],
      compact(
        concat(
          module.scalardl_apps_pool.iam_role_arn,
          module.default_node_pool.iam_role_arn,
        )
      )
    ) :
    {
      rolearn  = arn
      username = local.kubernetes_cluster.use_fargate_profile ? "system:node:{{SessionName}}" : "system:node:{{EC2PrivateDNSName}}"
      groups = compact(concat(
        [
          "system:bootstrappers",
          "system:nodes",
        ],
        local.kubernetes_cluster.use_fargate_profile ? ["system:node-proxier"] : []
      ))
    }
  ]

  map_roles = length(local.kubernetes_cluster.aws_auth_system_master_role) > 0 ? [
    {
      rolearn  = local.kubernetes_cluster.aws_auth_system_master_role
      username = local.kubernetes_cluster.use_fargate_profile ? "system:node:{{SessionName}}" : "system:node:{{EC2PrivateDNSName}}"
      groups   = ["system:masters"]
    },
  ] : []
}

data "aws_eks_cluster_auth" "eks_cluster" {
  name = aws_eks_cluster.eks_cluster.id
}

provider "kubernetes" {
  host                   = aws_eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.eks_cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.eks_cluster.token
  load_config_file       = false
  version                = "~> 1.11"
}

resource "null_resource" "wait_for_cluster" {
  count = local.kubernetes_cluster.cluster_endpoint_public_access ? 1 : 0

  depends_on = [
    aws_eks_cluster.eks_cluster,
  ]

  provisioner "local-exec" {
    command     = "curl --silent --fail --retry 60 --retry-delay 5 --retry-connrefused --insecure --output /dev/null $ENDPOINT/healthz"
    interpreter = ["/bin/sh", "-c"]
    environment = {
      ENDPOINT = aws_eks_cluster.eks_cluster.endpoint
    }
  }
}

resource "kubernetes_config_map" "aws_auth" {
  count = local.kubernetes_cluster.cluster_endpoint_public_access ? 1 : 0

  depends_on = [null_resource.wait_for_cluster[0]]

  metadata {
    name      = "aws-auth"
    namespace = "kube-system"
  }

  data = {
    mapRoles = yamlencode(distinct(concat(local.configmap_roles, local.map_roles)))
    # mapUsers    = yamlencode(var.map_additional_iam_users)
    # mapAccounts = yamlencode(var.map_additional_aws_accounts)
  }
}
