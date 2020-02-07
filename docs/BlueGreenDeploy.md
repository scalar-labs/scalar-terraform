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

* Green Cluster Active (Initial State)
```
#### Blue Cluster (inactive)
blue_scalardl_image_name=scalarlabs/scalar-ledger
blue_scalardl_image_tag=1.1.0
blue_resource_count=0

#### Green Cluster (active)
green_scalardl_image_name=scalarlabs/scalar-ledger
green_scalardl_image_tag=1.2.0
green_resource_count=3
```

* Deploy Blue Cluster version 1.3.0 (Step 1)
```
#### Blue Cluster (active)
blue_scalardl_image_name=scalarlabs/scalar-ledger
blue_scalardl_image_tag=1.3.0
blue_resource_count=3

#### Green Cluster (active)
green_scalardl_image_name=scalarlabs/scalar-ledger
green_scalardl_image_tag=1.2.0
green_resource_count=3
```

* Remove Green Cluster (Step 2)
```
#### Blue Cluster (active)
blue_scalardl_image_name=scalarlabs/scalar-ledger
blue_scalardl_image_tag=1.3.0
blue_resource_count=3

#### Green Cluster (inactive)
green_scalardl_image_name=scalarlabs/scalar-ledger
green_scalardl_image_tag=1.2.0
green_resource_count=0
```
