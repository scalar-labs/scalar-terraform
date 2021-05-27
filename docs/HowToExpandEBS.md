# A Guide on How to Expand EBS volumes in AWS

This guide explains how to expand EBS volumes in AWS.

## Stop processes

Stop the processes of a node that you want to expand the volume of.

For example in a Cassandra node, do as follows.
```console
$ sudo systemctl stop cassandra
```

## Resize the volume

Follow [the guide](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/requesting-ebs-volume-modifications.html#modify-ebs-volume).

## Expand a partition

Follow [the guide](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/recognize-expanded-volume-linux.html#extend-linux-volume-partition).

Please note that if you use Cassandra deployed with `scalar-terraform`, this step is probably not required since it doesn't create a partition on the Cassandra data volume and creates a filesystem directly on the volume.

## Extend the filesystem of the partition

Follow [the guide](https://docs.aws.amazon.com/AWSEC2/latest/UserGuide/recognize-expanded-volume-linux.html#extend-linux-file-system).

As of writing, `scalar-terraform` chooses XFS for a filesystem, so please use `xfs_growfs` to extend a filesystem.

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
For example, if you update the size of a data volume of Casssandra node to 2TB, please do as follows.

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

Third, do `terraform apply` to update tfstate.

```console
$ terraform apply -var-file=your.tfvars
```
