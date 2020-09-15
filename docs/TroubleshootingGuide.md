# Troubleshooting Guide

This is a guide for troubleshooting scalar-terraform environment. 

Use this Troubleshooting Guide to:
- Node Replacement

## Node Replacement
These troubleshooting steps can be used when the node cannot be replaced with normal procedures. This is especially useful when the node or os-disk is accidentally terminated in the **Azure** environment.
- Replace accidentally removed node or os-disk
- Replace accidentally removed cassandra node or os-disk with existing data disk

### Replace accidentally removed node or os-disk
The following process helps to replace accidentally terminated node or os-disk, but the node should not have an additional data disk.

Note: Mainly applicable for scalardl, envoy, cassy, reaper, monitor and ca nodes.
 
Please try the following
* Delete the os-disk If the node is terminated.
* Terminate the node If the os-disk is deleted.
* Follow [Node Replacement](NodeReplacement.md)

### Replace accidentally removed cassandra node or os-disk with existing data disk
This documentation helps to replace accidentally terminated node or os-disk with existing data disk (taint volume attachment).

Please try the following
* Delete the os-disk If the node is terminated.
* Terminate the node If the os-disk is deleted.
* Do `terraform state rm` as follows.
  
```console
terraform state rm "module.cassandra.module.cassandra_cluster.azurerm_virtual_machine.vm-linux[0]"
terraform state rm "module.cassandra.azurerm_virtual_machine_data_disk_attachment.cassandra_data_volume_attachment[0]"

terraform apply
```

Follow [Cassandra Post Recovery Steps](CassandraOperation.md#post-recovery-steps)
