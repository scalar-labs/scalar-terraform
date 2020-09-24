# A Guide on How to Expand Managed Disk in Azure

This guide explains how to expand managed disk in Azure.

## Stop processes

Stop the processes of a node that you want to expand the disk of.

For example in a Cassandra node, do as follows.

```console
$ sudo systemctl stop cassandra
```

## Stop the VM (or Detach disk from VM)

Follow [the guide](https://docs.microsoft.com/en-us/azure/devtest-labs/devtest-lab-attach-detach-data-disk#detach-a-data-disk)

## Resize the disk

Follow [the guide](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/expand-disks#expand-an-azure-managed-disk)

## Start the VM (or Attach the disk)

Follow [the guide](https://docs.microsoft.com/en-us/azure/devtest-labs/devtest-lab-attach-detach-data-disk#attach-a-data-disk)

Note that the `LUN` must be chosen with appropriate value when using `Attach disk`

- `5` is for Cassandra data disk or Monitor log disk.
- `6` is for Cassandra commitlog disk.

## Expand a partition

Follow [the guide](https://docs.microsoft.com/en-us/azure/virtual-machines/linux/expand-disks#expand-a-disk-partition-and-filesystem)

```console
$ sudo systemctl stop cassandra
$ sudo xfs_growfs /dev/xxx
```

## Start the processes

Start the processes of a node that you expanded the volume of.

For example in a Cassandra node, do as follows.

```console
$ sudo systemctl start cassandra
```

## Do the above operations on each node in the same cluster

Since `scalar-terraform` manages a set of nodes in a cluster (e.g. Cassandra cluster) in the same way, it is not allowed to change the resource configuration of only part of the nodes. So please update all the nodes in the same cluster in the same way.
For example, if you update the volume size of a Cassandra node from 1TB to 2TB, you need to update the volumes of the other Cassandra nodes to 2TB as well.

## Update tfstate

Since the above operations are done manually without using terraform, the actual states of cloud resources and tfstate are not consistent after the above steps. Please do the following to update tfstate to make it consistent with the actual resources.

First, update the tfvars of a terraform module of a resource that you updated to match with the actual states of the resource.
For example, if you update the size of a data volume of Cassandra node to 2TB, please do as follows.

```console
$ vim your.tfvars  # the filename is environment dependent

## add only the `data_remote_volume_size = "2048"` line  if there is already a cassandra block.
cassandra = {
  data_remote_volume_size = "2048"
}
```

Second, do `terraform plan` to check if Cloud resources' states are the same as what you are planning to apply.

```console
$ terraform plan -var-file=your.tfvars
```

Third, do `terraform refresh` to update tfstate.

```console
$ terraform refresh -var-file=your.tfvars
```
