# Troubleshooting Guide

This is a guide for troubleshooting scalar-terraform environment. 

## Accidental deletion of resources
When you accidentally delete a resource manually without terraform, it causes some inconsistencies between the actual state of resources and the state that terraform knows. Thus, you might need to take some extra actions to recover from such situations depending on the Cloud you use.

### Recover from accidental deletion of a node in Azure
If you accidentally delete a node that does not have an additional data disk in Azure, you can recover it in the following steps. It is mainly applicable for scalardl, envoy, cassy, reaper, monitor and ca nodes.

* Delete the os-disk If the node is terminated.
* Follow [Node Replacement](NodeReplacement.md)

### Recover a node with existing data disk from accidental deletion of a node in Azure
If you accidentally delete a node that contains an additional data disk in Azure, you can recover that node with an existing data disk using the following steps.

* Delete the os-disk If the node is terminated.
* Do `terraform state rm` as follows.
```console
terraform state rm "module.cassandra.module.cassandra_cluster.azurerm_virtual_machine.vm-linux[0]"
terraform state rm "module.cassandra.azurerm_virtual_machine_data_disk_attachment.cassandra_data_volume_attachment[0]"
```
* Do `terraform apply`

Follow [Cassandra Post Terraform Steps](CassandraOperation.md#post-terraform-steps)

### Recover a node with a data disk from accidental deletion of both the node and the data disk in Azure
If you accidentally delete a node and data disk in Azure, you can recover that node and data disk using the following steps.

* Delete the os-disk If the node is terminated.
* Do `terraform state rm` as follows.
```console
terraform state rm "module.cassandra.module.cassandra_cluster.azurerm_virtual_machine.vm-linux[0]"
terraform state rm "module.cassandra.azurerm_virtual_machine_data_disk_attachment.cassandra_data_volume_attachment[0]"
terraform state rm "module.cassandra.azurerm_managed_disk.cassandra_data_volume[0]"
```
* Do `terraform apply`

Follow [Cassandra Post Terraform Steps](CassandraOperation.md#post-terraform-steps-2)


