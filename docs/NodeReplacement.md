# Guide on How to Replace a Node
This guide explains how to replace a node.
A node needs to be replaced in several cases such as when you want to recover the node since it is broken, upgrade the software in the node, and upgrade/downgrade the node itself.

You will need to do a combination of taint and apply commands. It destroys and re-creates an instance (a virtual machine) in a cloud, then runs provisioning that installs and configures software, such as Docker.

The process of replacement is as follows.

1. `terraform taint` for a node intance resource
2. `terraform apply`

Note that when tainting a resource, you need to go to the directory where the resource was created. The second part of the resource name represents the module name. For example, if you need to taint a resource `module.scalardl.module.foo.aws_instance.this[0]`, you need to go to `scalardl` directory first.

The following sections will show what to taint with the `terraform taint` command.

## Refresh Ansible Playbooks

When you try to replace a node of any kind, the first thing you need to do is refresh Ansible playbooks that are kept on the bastion host, in case any playbook files are updated since the last deployment.

The following is the resource you need to taint.

```
module.network.module.bastion.module.bastion_provision.null_resource.ansible_playbooks_copy[0]
```

## Scalar DL

```
# AWS
module.scalardl.module.scalardl_blue.module.scalardl_cluster.aws_instance.this[0]
module.scalardl.module.scalardl_blue.module.scalardl_provision.null_resource.schema_loader_image[0]
module.scalardl.module.scalardl_blue.module.scalardl_provision.null_resource.scalardl_image[0]
# Azure
module.scalardl.module.scalardl_blue.module.cluster.azurerm_virtual_machine.vm-linux[0]
module.scalardl.module.scalardl_blue.module.scalardl_provision.null_resource.schema_loader_image[0]
module.scalardl.module.scalardl_blue.module.scalardl_provision.null_resource.scalardl_image[0]
```

* The index for `aws_instance.this` or `azurerm_virtual_machine.vm-linux` should be changed according to the node you want to replace.
* If you replace a `green` node, replace `blue` in the resource names with `green`.


## Envoy

```
# AWS
module.scalardl.module.envoy_cluster.aws_instance.this[0]
# Azure
module.scalardl.module.envoy_cluster.azurerm_virtual_machine.vm-linux[0]
```

## Cassandra

See [CassandraOperation](CassandraOperation.md).

## Cassy

```
# AWS
module.cassandra.module.cassy_cluster.aws_instance.this[0]
# Azure
module.cassandra.module.cassy_cluster.azurerm_virtual_machine.vm-linux[0]
```

## Reaper

```
# AWS
module.cassandra.module.reaper_cluster.aws_instance.this[0]
# Azure
module.cassandra.module.reaper_cluster.azurerm_virtual_machine.vm-linux[0]
```


## Monitor

```
# AWS
module.monitor.module.monitor_cluster.aws_instance.this[0]
# Azure
module.monitor.module.monitor_cluster.azurerm_virtual_machine.vm-linux[0]
```

After the replacement is done, you should make sure the volume for logs is attached again to the new instance, and it's mounted and symlinked from `/log`.

```console
$ ls -l /log
/log -> /mnt/block/vol5
```

## ca

```
# AWS
module.ca.module.ca_cluster.aws_instance.this[0]
# Azure
module.ca.module.ca_cluster.azurerm_virtual_machine.vm-linux[0]
```
