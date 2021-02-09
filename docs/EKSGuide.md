# Amazon EKS Guide

## [Amazon EKS cluster endpoint access control](https://docs.aws.amazon.com/eks/latest/userguide/cluster-endpoint.html)

By default, `scalar-terraform` will create eks cluster with `Public and private` endpoint access.
It is recommended to enable both public and private endpoint access by `public_cluster_enabled = "true"` when first build an environment.
This is an important prerequisite for creating [aws-auth ConfigMap](#managing-bastion-role-for-eks-cluster) and [Autoscaler](#managing-cluster-autoscaler-for-node-autoscaling) with `scalar-terraform`.

```terraform
region = "ap-northeast-1"

kubernetes_cluster = {
  cluster_endpoint_public_access_cidrs = "0.0.0.0/0"
  public_cluster_enabled               = "true"
}
```

## Managing bastion role for EKS cluster

To grant bastion role the ability to interact with your cluster, you must edit the aws-auth ConfigMap within Kubernetes.
By default, `scalar-terraform` will automatically create when you use the public access endpoint.

If you want to add permissions manually, see [Managing users or IAM roles for your cluster](https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html).

## Managing Cluster Autoscaler for node autoscaling

The Cluster Autoscaler minimizes costs by ensuring that nodes are only added to the cluster when needed and are removed when unused.
To enable autoscaling with `cluster_auto_scaling = "true"` and `scalar-terraform` will automatically deploy autoscaler when you use the public access endpoint.

```terraform
region = "ap-northeast-1"

kubernetes_cluster = {
  cluster_auto_scaling = "true"
}
```

If you want to add autoscaler manually, see [Deploy the Cluster Autoscaler](https://docs.aws.amazon.com/eks/latest/userguide/cluster-autoscaler.html#ca-deploy).

## Update EKS cluster endpoint access to `Private`

To enable private access to the Kubernetes API server so that all communication between your nodes and the API server stays within your VPC.
Any `kubectl` commands must come from within the VPC or a connected network. For connectivity options, see [Accessing a private only API server](https://docs.aws.amazon.com/eks/latest/userguide/cluster-endpoint.html#private-access).

- Edit [example.tfvars](https://github.com/scalar-labs/scalar-terraform-examples/blob/main/aws/kubernetes/example.tfvars)

```terraform
region = "ap-northeast-1"

kubernetes_cluster = {
  public_cluster_enabled = "false"
}
```

- Terraform apply

```console
cd aws/kubernetes
terraform init
terraform apply -var-file example.tfvars
```

## Update EKS cluster endpoint access from `Private` to `Public and private`

Because `scalar-terraform` does not support yet, so please change from the AWS console, AWS CLI, see [Modifying cluster endpoint access](https://docs.aws.amazon.com/eks/latest/userguide/cluster-endpoint.html#modify-endpoint-access).
