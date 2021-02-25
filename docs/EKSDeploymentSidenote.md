# Sidenotes on how to create a Kubernetes cluster in Amazon EKS with scalar-terraform

## Manage bastion role for an EKS cluster

To grant bastion role the ability to interact with your cluster, you must edit the aws-auth ConfigMap within Kubernetes.
By default, `scalar-terraform` will automatically create when `public_cluster_enabled` is set true (true by default).

If you want to add permissions manually, see [Managing users or IAM roles for your cluster](https://docs.aws.amazon.com/eks/latest/userguide/add-user-role.html).

## Manage Cluster Autoscaler for node autoscaling

The Cluster Autoscaler minimizes costs by ensuring that nodes are only added to the cluster when needed and are removed when unused.
With `cluster_auto_scaling = "true"`,  `scalar-terraform` automatically deploys Autoscaler when `public_cluster_enabled` is set true (true by default).

```terraform
region = "ap-northeast-1"

kubernetes_cluster = {
  cluster_auto_scaling = "true"
}
```

If you want to add Autoscaler manually, see [Deploy the Cluster Autoscaler](https://docs.aws.amazon.com/eks/latest/userguide/cluster-autoscaler.html#ca-deploy).

## Update EKS cluster endpoint access to `Private`

To disable public access for your cluster's Kubernetes API server endpoint, please follow the steps below.

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

Since `scalar-terraform` does not support the flow yet, please change it from the AWS console, AWS CLI, see [Modifying cluster endpoint access](https://docs.aws.amazon.com/eks/latest/userguide/cluster-endpoint.html#modify-endpoint-access).
