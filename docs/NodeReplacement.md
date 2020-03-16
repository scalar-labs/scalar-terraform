# Guide on How to Replace a Node
This guide explains how to replace a node.
A node needs to be replaced in several cases such as when you want to recover the node since it is broken, upgrade the software in the node, and upgrade/downgrade the node itself.

The basic process of replacement is as follows.
1. `terraform taint` for required resources 
1. `terraform apply` to remove the resources and create new resources 

There are not many things to talk about the second step, so this guide will focus on the first step; what resource you need to taint.

## Scalar DL

## Cassy

In AWS
```
module.scalar-network.module.bastion.module.bastion_provision.null_resource.ansible_playbooks_copy[0]
module.cassandra.module.cassy_provision.null_resource.cassy_waitfor[0]
module.cassandra.module.cassy_provision.null_resource.docker_install[0]
module.cassandra.module.cassy_cluster.aws_instance.this[0]
```


