# Cassandra Operations
The Cassandra cluster can be expanded using terraform but due to the sensitive nature of Cassandra it requires additional steps.

## Scale up the Cassandra cluster
By setting the `cassandra.resource_count` variable you can control the number of Cassandra nodes to create. 
All Cassandra nodes will be created in a stopped state and will need an operator to manually start the service.

[ [Azure example.tfvars](../examples/azure/cassandra/example.tfvars) ]
[ [AWS example.tfvars](../examples/aws/cassandra/example.tfvars) ]
```
cassandra = {
  resource_type             = "t3.large"
  resource_count            = 3
  resource_root_volume_size = 64
  enable_data_volume        = true  
  data_remote_volume_size   = 64
}
```

* If you lower the *resource_count* terraform will destroy the newest node first. It is best to avoid lowering the Cassandra count if possible.
* The first 3 Cassandra nodes will be setup as seed nodes.
* It is only possible to add 1 node to a cluster at a time.
* Also when adding a new node to a cluster it will slow down the system.

## Replace a Cassandra Node

There are basically three ways to replace a Cassandra node as follows.

1. Replace the node, but not the volume
2. Replace the volume of the node, but not the node
3. Replace both the node and the volume


This section explains what needs to be done for each case.

### Case 1: Replace the node, but not the volume

When a node (VM or instance) is not working properly for some reason but the volume is fully functioning, only the node should be replaced with a new one.
You can replace the node by tainting the VM or the instance and the volume attachment as described below.
Note that, when you taint the volume attachment, terraform will try to attach the same data or commit log volume to the new instance.

#### Azure
```console
terraform taint "module.cassandra.module.cassandra_cluster.azurerm_virtual_machine.vm-linux[0]"
terraform taint "module.cassandra.azurerm_virtual_machine_data_disk_attachment.cassandra_data_volume_attachment[0]"

terraform apply
```
#### AWS
```console
terraform taint "module.cassandra.module.cassandra_cluster.aws_instance.this[0]"
terraform taint "module.cassandra.aws_volume_attachment.cassandra_data_volume_attachment[0]"

terraform apply
```
#### Post Terraform Steps
After the Cassandra node is replaced, you will need to perform the following manual steps to get the node back in the cluster.

* Find the UUID of the `data` or `commitlog` volume and add it to `fstab`.

```console
ssh -F ssh.cfg cassandra-[].internal.scalar-labs.com
lsblk -p -P -d -o name,serial,UUID,SIZE
NAME="/dev/nvme2n1" SERIAL="vol018d1871d19da76f1" UUID="af767839-b23d-4d1f-8a19-debbcfd6413c" HCTL="" SIZE="1T"
...

mkdir /data
chown cassandra:cassandra /data
sudo /bin/bash -c "echo 'UUID=af767839-b23d-4d1f-8a19-debbcfd6413c /data xfs defaults,nofail 0 2' >> /etc/fstab"
sudo mount -a
```

* Remove the IP of the new node from seeds in `casssandra.yaml`
* Add `JVM_OPTS="$JVM_OPTS -Dcassandra.replace_address_first_boot=<dead node ip>"` to the bottom of `cassandra-env.sh`
* `sudo systemctl start cassandra`
* Repair with Reaper at some later point 

Please note that, if you replace a seed node (IP-A), you should replace IP-A from seeds with a newly created Cassandra node IP in all the Cassandra nodes.

### Case 2: Replace the volume of the node, but not the node

When the volume is not functioning properly for some reason but the node is alive, only the volume should be replaced with a new one.
You can replace the volume by tainting the volume as described below.
Note that this *will permanently delete data* on that volume and attach the recreated data or commit log volume to the existing node.  
When you do this, it is recommended to recover data from backup.

#### Azure
```console
terraform taint "module.cassandra.azurerm_managed_disk.cassandra_data_volume[0]"

terraform apply
```

#### AWS
```console
terraform taint "module.cassandra.aws_ebs_volume.cassandra_data_volume[0]"

terraform apply
```

#### Post Terraform Steps
After the volume is replaced, you will need to perform the following manual steps to get the volume back in the node.

* Replace the UUID of the `data` or `commitlog` volume in `fstab`.

```console 
ssh -F ssh.cfg cassandra-[].internal.scalar-labs.com

# Find the name of newly attached EBS volume
lsblk -p -P -d -o name,serial,SIZE
NAME="/dev/nvme2n1" SERIAL="vol018d1871d19da76f1" HCTL="" SIZE="1T"
...

# Create a file system in the newly created volume
sudo mkfs -t xfs <name of volume>

# Find the `UUID` of the data or commit log volume
lsblk -p -P -d -o name,serial,UUID,SIZE
NAME="/dev/nvme2n1" SERIAL="vol018d1871d19da76f1" UUID="af767839-b23d-4d1f-8a19-debbcfd6413c" HCTL="" SIZE="1T"
...

# Update the UUID of `/data` or `/commitlog` directory 
sudo vi /etc/fstab

sudo systemctl daemon-reload

sudo mount -a

# Change ownership of `/data` directory 
sudo chown cassandra:cassandra /data
```
* Restore data from Cassy
* `sudo systemctl start cassandra`
* Repair with Reaper at some later point 

### Case 3: Replace both the node and the volume

When both a node and the volume are not working properly, both resources should be replaced with new ones.
You can do it by tainting both resources as described below.
Since the volume is replaced in the same manner as the 2nd option, the data on that volume will be permanently deleted.

#### Azure
```console
terraform taint "module.cassandra.module.cassandra_cluster.azurerm_virtual_machine.vm-linux[0]"
terraform taint "module.cassandra.azurerm_managed_disk.cassandra_data_volume[0]"

terraform apply
```

#### AWS
```console
terraform taint "module.cassandra.module.cassandra_cluster.aws_instance.this[0]"
terraform taint "module.cassandra.aws_ebs_volume.cassandra_data_volume[0]"

terraform apply
```

#### Post Terraform Steps
After the Cassandra node and volume are replaced, you will need to perform the following manual steps to get the node back in the cluster.

* Restore data from Cassy
  * You need to manually update the IP of the entry of `backup_history` table to match with the new IP
  * You need to manually update the IP address of Cassy backup with new IP in the cloud storage
* Remove the IP of the new node from seeds in `casssandra.yaml`
* Set `auto_bootstrap` to `false` in `cassandra.yaml`
    * this might not be needed. need to verify.
* Add `JVM_OPTS="$JVM_OPTS -Dcassandra.replace_address_first_boot=<dead node ip>"` to the bottom of `cassandra-env.sh`
* `sudo systemctl start cassandra`
* Repair with Reaper at some later point 

Please note that, if you replace a seed node (IP-A), you should replace IP-A from seeds with a newly created Cassandra node IP in all the Cassandra nodes.


# Related Documents

* [How to Expand EBS volumes in AWS](./HowToExpandEBS.md)
* [Drive Mount Script](./DrivemountScript.md)
* [Cassandra Cluster Down Alert](./CassandraClusterDown.md)
* [Cassandra Drive Space Low Alert](./CassandraDriveSpaceLow.md)
* [Cassandra Process Stopped Alert](./CassandraProcessStopped.md)
