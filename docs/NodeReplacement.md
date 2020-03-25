# Guide on How to Replace a Node
This guide explains how to replace a node.
A node needs to be replaced in several cases such as when you want to recover the node since it is broken, upgrade the software in the node, and upgrade/downgrade the node itself.

You will need to do a combination of taint and apply commands for two resources step by step. First step is to destroy and create an instance (a virtual machine) in the cloud, and the second is to run the provisioning that sets up tools in the instance, such as installing Docker.

If those steps are done at once, the second step can be run on the existing instance without waiting for the new instance to be created. So the proces of replacement is as follows.

1. `terraform taint` for a node intance resource
2. `terraform apply`
3. `terraform taint` for a `null_resource` that runs provisioning on the new node
4. `terraform apply`

Note that when tainting a resource, you need to go to the directory where the resource was created. The second part of the resource name represents the module name. For example, if you need to taint a resource `module.scalardl.module.foo.aws_instance.this[0]`, you need to do first `cd scalardl`.

In the sections for each module below in this guide, the resources you will need to taint at the step 1 and 3 above are listed.

## Refresh Ansible Playbooks

When you try to replace a node of any kind, first of all, it is necessary to refresh Ansible playbooks that are kept on the bastion host, in case any playbook files are updated since last deployment.

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
    * If you are replacing a `green` node, change `blue` in the resource neames with `green`.

2. Provisioning

    ```
    module.scalardl.module.scalardl_blue.module.scalardl_provision.null_resource.scalardl_image[0]
    ```

    Note: Tainting `null_resource.scalardl_image[0]` causes re-install the Scalar DL Docker image not only on a new node but also on existing nodes. But it does not affect the system because `docker-compose up` doesn't take effect the second time.

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
