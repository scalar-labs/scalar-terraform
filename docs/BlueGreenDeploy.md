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
[ [Azure example.tfvars](https://github.com/scalar-labs/scalar-terraform-examples/blob/master/azure/scalardl/example.tfvars) ]
[ [AWS example.tfvars](https://github.com/scalar-labs/scalar-terraform-examples/blob/master/aws/scalardl/example.tfvars) ]

* Blue cluster is in an active state (initial state)
```
#### Blue Cluster (active), Green Cluster (inactive)
scalardl = {
  blue_resource_count         = "3"
  blue_image_tag              = "2.0.1"
  blue_image_name             = "ghcr.io/scalar-labs/scalar-ledger"
  blue_discoverable_by_envoy  = "true"
  green_resource_count        = "0"
  green_image_tag             = "2.0.1"
  green_image_name            = "ghcr.io/scalar-labs/scalar-ledger"
  green_discoverable_by_envoy = "false"
}
```

* Deploy green cluster version 2.1.0 (Step 1)
```
scalardl = {
  blue_resource_count         = "3"
  blue_image_tag              = "2.0.1"
  blue_image_name             = "ghcr.io/scalar-labs/scalar-ledger"
  blue_discoverable_by_envoy  = "true"
  green_resource_count        = "3"
  green_image_tag             = "2.1.0"
  green_image_name            = "ghcr.io/scalar-labs/scalar-ledger"
  green_discoverable_by_envoy = "true" # <- this is set to `true`
}
```

* Make blue cluster not discoverable by Envoy (Step 2)
This makes all the requests from Envoy will go to green eventually.
```
scalardl = {
  blue_resource_count         = "3"
  blue_image_tag              = "2.0.1"
  blue_image_name             = "ghcr.io/scalar-labs/scalar-ledger"
  blue_discoverable_by_envoy  = "false" # <- this is set to `false`
  green_resource_count        = "3"
  green_image_tag             = "2.1.0"
  green_image_name            = "ghcr.io/scalar-labs/scalar-ledger"
  green_discoverable_by_envoy = "true"
}
```

* Remove blue cluster (Step 3)
It should be done after making sure that requests from Envoy are not going to blue any more.
```
scalardl = {
  blue_resource_count         = "0" # <- this is set to 0
  blue_image_tag              = "2.0.1"
  blue_image_name             = "ghcr.io/scalar-labs/scalar-ledger"
  blue_discoverable_by_envoy  = "false"
  green_resource_count        = "3"
  green_image_tag             = "2.1.0"
  green_image_name            = "ghcr.io/scalar-labs/scalar-ledger"
  green_discoverable_by_envoy = "true"
}
```
