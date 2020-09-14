# Troubleshoot Guide

This guide explains how to replace a node when the node cannot be replaced with normal procedures. This is especially useful when the node or os-disk is accidentally terminated in the **Azure** environment.

Use this Troubleshooting Guide to:
- Replace accidentally removed node or os-disk
- Replace accidentally removed cassandra node or os-disk with existing data disk

## Replace accidentally removed node or os-disk
The following process helps to replace accidentally terminated node or os-disk, but that node should not have an additional data disk.

Note: Mainly applicable for scalardl, envoy, cassy, reaper, monitor and ca nodes.
 
Please try the following
- Remove the os-disk If the node is not available in the resource group.
- Remove the node If the os-disk is not available in the resource group.
- Then you can follow [Node Replacement](NodeReplacement.md)

## Replace accidentally removed cassandra node or os-disk with existing data disk
This documentation helps to replace accidentally terminated node or os-disk with existing data disk (taint volume attachment).

Please try the following
* Remove the os-disk If the node is not available in the resource group.
* Remove the node If the os-disk is not available in the resource group.
* Do `terraform state rm` as follows.
  
```console
terraform taint "module.cassandra.module.cassandra_cluster.azurerm_virtual_machine.vm-linux[0]"
terraform state rm "module.cassandra.azurerm_virtual_machine_data_disk_attachment.cassandra_data_volume_attachment[0]"

terraform apply
```

Then you can follow [Cassandra Post Recovery Steps](CassandraOperation.md#post-recovery-steps)