# Troubleshooting Guide

This is a guide for troubleshooting scalar-terraform environment. 

## Accidental deletion of resources
When you accidentally delete a resource manually without terraform, it causes some inconsistencies between the actual state of resources and the state that terraform knows. Thus, you might need to take some extra actions to recover from such situations depending on the Cloud you use.

### Recover from accidental deletion of a node in Azure
If you accidentally delete a node that does not have an additional data disk in Azure, you can recover it in the following steps. It is mainly applicable for scalardl, envoy, cassy, reaper, monitor and ca nodes.

Please try the following
* Delete the os-disk If the node is terminated.
* Follow [Node Replacement](NodeReplacement.md)

### Recover a node with existing data disk from accidental deletion of a node in Azure
If you accidentally delete a node that contains an additional data disk in Azure, you can recover that node with an existing data disk using the following steps.

Please try the following
* Delete the os-disk If the node is terminated.
* Do `terraform state rm` as follows.
  
```console
terraform state rm "module.cassandra.module.cassandra_cluster.azurerm_virtual_machine.vm-linux[0]"
terraform state rm "module.cassandra.azurerm_virtual_machine_data_disk_attachment.cassandra_data_volume_attachment[0]"

terraform apply
```

Follow [Cassandra Post Recovery Steps](CassandraOperation.md#post-recovery-steps)

## Replace accidentally deleted node or disk after initial configuration of shared environment

When an error is faced like `module does not exist` while recreating the accidentally deleted node or disk using `terraform state rm` or `terraform taint` command after configuring share environment in the local system, following workaround

There is no need to execute `terraform state rm` or `terraform taint` command for node or disk replacement.
Because terminated node or disk modules will be removed from `tfstate` file while executing `terraform refresh` command for replacing the keys in `tfstate` file as part of [ShareEnvironment](ShareEnvironment.md).

So terminated node can be simply replaced with `terraform apply` command.
