# Blue Green Deployment
The Scalar DL module provides a blue green deployment feature allowing for a smooth transition between versions. The deployment process involves two steps, first creating a new cluster with an updated version and second removing the old cluster.

This module manages two Scalar DL clusters, blue and green. At any given time only one cluster should be active, except during deployment when both clusters will be active. The operator needs to verify the health of the new cluster before removing the old one.

## Deployment Steps
* Update variable file to change the tag version and resource count of the inactive cluster
* Make a new terraform plan and apply it to the environment
* Monitor the cluster health to know when the new cluster is running
* Update variable file to change the resource count of old cluster to 0
* Make a new terraform plan and apply it to the environment

## Example Config
Azure: `../examples/azure/scalardl/example.tfvars`
AWS: `../examples/aws/scalardl/example.tfvars`

* Green Cluster Active (Initial State)
```
#### Blue Cluster (inactive), Green Cluster (active)
scalardl = {
  blue_resource_count  = 0
  blue_image_tag       = "2.0.1"
  blue_image_name      = "scalarlabs/scalar-ledger"
  green_resource_count = 3
  green_image_tag      = "2.0.1"
  green_image_name     = "scalarlabs/scalar-ledger"
}
```

* Deploy Blue Cluster version 2.1.0 (Step 1)
```
scalardl = {
  blue_resource_count  = 3
  blue_image_tag       = "2.1.0"
  blue_image_name      = "scalarlabs/scalar-ledger"
  green_resource_count = 3
  green_image_tag      = "2.0.1"
  green_image_name     = "scalarlabs/scalar-ledger"
}
```

* Remove Green Cluster (Step 2)
```
scalardl = {
  blue_resource_count  = 3
  blue_image_tag       = "2.1.0"
  blue_image_name      = "scalarlabs/scalar-ledger"
  green_resource_count = 0
  green_image_tag      = "2.0.1"
  green_image_name     = "scalarlabs/scalar-ledger"
}
```
