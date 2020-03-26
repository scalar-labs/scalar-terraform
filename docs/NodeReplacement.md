# Guide on How to Replace a Node
This guide explains how to replace a node.
A node needs to be replaced in several cases such as when you want to recover the node since it is broken, upgrade the software in the node, and upgrade/downgrade the node itself.

You will need to do a combination of taint and apply commands for two resources step by step. First step is to destroy and create an instance (a virtual machine) in a cloud, and the second is to run the provisioning that installs and configures software in the instance, such as installing Docker.

The reason why those steps should be done step by step is that the second step could start running on an existing instance without waiting for a new instance to be created. 

The process of replacement is as follows.

1. `terraform taint` for a node intance resource
2. `terraform apply`
3. `terraform taint` for a `null_resource` that runs provisioning on the new node
4. `terraform apply`

Note that when tainting a resource, you need to go to the directory where the resource was created. The second part of the resource name represents the module name. For example, if you need to taint a resource `module.scalardl.module.foo.aws_instance.this[0]`, you need to go to `scalardl` directory first.

The following sections will show what to taint in step 1 and 3.

## Refresh Ansible Playbooks

When you try to replace a node of any kind, the first thing you need to do is refresh Ansible playbooks that are kept on the bastion host, in case any playbook files are updated since the last deployment.

The following is the resource you need to taint.

```
module.network.module.bastion.module.bastion_provision.null_resource.ansible_playbooks_copy[0]
```

## Scalar DL

1. Instance

    ```
    # AWS
    module.scalardl.module.scalardl_blue.module.scalardl_cluster.aws_instance.this[0]
    # Azure
    module.scalardl.module.scalardl_blue.module.cluster.azurerm_virtual_machine.vm-linux[0]
    ```

    * The index for `aws_instance.this` or `azurerm_virtual_machine.vm-linux` should be changed according to the node you want to replace.
    * The index for `scalardl_image` is always `0` since it is the only one resource.
    * If you are replacing a `green` node, change `blue` in the resource names with `green`.

2. Provisioning

    ```
    module.scalardl.module.scalardl_blue.module.scalardl_provision.null_resource.scalardl_image[0]
    ```

    Note: Tainting `null_resource.scalardl_image[0]` causes re-installing the Scalar DL Docker image (scalar-ledger) not only on a new node but also on existing nodes that have already run the image in a cluster. But it does not affect the existing nodes because `docker-compose up` won't be executed if an image is the same as the currently running image.

## Envoy

1. Instance

    ```
    # AWS
    module.scalardl.module.envoy_cluster.aws_instance.this[0]
    # Azure
    module.scalardl.module.envoy_cluster.azurerm_virtual_machine.vm-linux[0]
    ```

2. Provisioning

    ```
    module.scalardl.module.envoy_provision.null_resource.envoy_waitfor[0]
    ```

## Cassandra

See [CassandraOperation](CassandraOperation.md).

## Cassy

1. Instance

    ```
    # AWS
    module.cassandra.module.cassy_cluster.aws_instance.this[0]
    # Azure
    module.cassandra.module.cassy_cluster.azurerm_virtual_machine.vm-linux[0]
    ```

2. Provisioning

    ```
    module.cassandra.module.cassy_provision.null_resource.cassy_waitfor[0]
    ```

## Reaper

1. Instance

    ```
    # AWS
    module.cassandra.module.reaper_cluster.aws_instance.this[0]
    # Azure
    module.cassandra.module.reaper_cluster.azurerm_virtual_machine.vm-linux[0]
    ```

2. Provisioning

    ```
    module.cassandra.module.reaper_provision.null_resource.reaper_waitfor[0]
    ```

## Monitor

1. Instance

    ```
    # AWS
    module.monitor.module.monitor_cluster.aws_instance.this[0]
    # Azure
    module.monitor.module.monitor_cluster.azurerm_virtual_machine.vm-linux[0]
    ```

2. Provisioning

    ```
    module.monitor.module.monitor_provision.null_resource.monitor_waitfor[0]
    ```

After the provisioning is done, you should make sure the volume for logs is attached again to the new instance, and it's mounted and symlinked from `/log`.

```console
$ ls -l /log
/log -> /mnt/block/vol5
```

## ca

1. Instance

    ```
    # AWS
    module.ca.module.ca_cluster.aws_instance.this[0]
    # Azure
    module.ca.module.ca_cluster.azurerm_virtual_machine.vm-linux[0]
    ```

2. Provisioning

    ```
    module.ca.module.ca_provision.null_resource.ca_waitfor[0]
    ```
