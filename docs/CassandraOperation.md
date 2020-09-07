## Cassandra
The Cassandra cluster can be expanded using terraform but due to the sensitive nature of Cassandra it requires additional steps.

### Scale up the Cassandra cluster
By setting the `cassandra.resource_count` variable you can control the number of Cassandra nodes to create. All Cassandra nodes will be created in a stopped state and will need an operator to manually start the service.

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

### Replace a Cassandra Node
The following section is useful when you need to replace a Cassandra node.

* The first thing to do is to match the Terraform state file to the actual resource you want to replace.
* This step can be tricky and error prone, so please be careful.
* Match the private_ip address of the VM to the state file using the command below.
* You may want to add `-A 10` to the grep command to help find the correct node.

#### Azure Output
```console
terraform show | grep module.cassandra
# module.cassandra.module.reaper_cluster.azurerm_virtual_machine.vm-linux[0]:
# module.cassandra.module.cassandra_cluster.azurerm_virtual_machine.vm-linux[2]:
# module.cassandra.module.cassandra_cluster.azurerm_virtual_machine.vm-linux[0]:
# module.cassandra.module.cassandra_cluster.azurerm_virtual_machine.vm-linux[1]:
# module.cassandra.azurerm_managed_disk.cassandra_data_volume[0]:
# module.cassandra.azurerm_managed_disk.cassandra_data_volume[1]:
# module.cassandra.azurerm_managed_disk.cassandra_data_volume[2]:
# module.cassandra.azurerm_virtual_machine_data_disk_attachment.cassandra_data_volume_attachment[0]:
# module.cassandra.azurerm_virtual_machine_data_disk_attachment.cassandra_data_volume_attachment[1]:
# module.cassandra.azurerm_virtual_machine_data_disk_attachment.cassandra_data_volume_attachment[2]:
# module.cassandra.null_resource.volume_data_local[0]:
```

#### AWS Output
```console
terraform show | grep module.cassandra
# module.cassandra.module.cassandra_cluster.aws_instance.this[0]:
# module.cassandra.module.cassandra_cluster.aws_instance.this[1]:
# module.cassandra.module.cassandra_cluster.aws_instance.this[2]:
# module.cassandra.aws_ebs_volume.cassandra_data_volume[0]:
# module.cassandra.aws_ebs_volume.cassandra_data_volume[1]:
# module.cassandra.aws_ebs_volume.cassandra_data_volume[2]:
# module.cassandra.aws_volume_attachment.cassandra_data_volume_attachment[0]:
# module.cassandra.aws_volume_attachment.cassandra_data_volume_attachment[1]:
# module.cassandra.aws_volume_attachment.cassandra_data_volume_attachment[2]:
```

* Find the `instance` or `vm` you wish to replace and copy the line.
* You also need to decide to taint either the *drive attachment* or the *volume* directly.

#### Taint volume attachment
When you taint the volume attachment terraform will try to attach the same data or commit log volume to the new instance. This is the ideal situation as it is the quickest way to replace a node.

##### Azure
```console
terraform taint "module.cassandra.module.cassandra_cluster.azurerm_virtual_machine.vm-linux[0]"
terraform taint "module.cassandra.azurerm_virtual_machine_data_disk_attachment.cassandra_data_volume_attachment[0]"

terraform apply
```
##### AWS
```console
terraform taint "module.cassandra.module.cassandra_cluster.aws_instance.this[0]"
terraform taint "module.cassandra.aws_volume_attachment.cassandra_data_volume_attachment[0]"

terraform apply
```

#### Taint Volume
The other option is to taint the volume which should be used as a last resort. This *will permanently delete data* on that volume. Be sure you can recover the data from a backup first.

##### Azure
```console
terraform taint "module.cassandra.module.cassandra_cluster.azurerm_virtual_machine.vm-linux[0]"
terraform taint "module.cassandra.azurerm_managed_disk.cassandra_data_volume[0]"

terraform apply
```

##### AWS
```console
terraform taint "module.cassandra.module.cassandra_cluster.aws_instance.this[0]"
terraform taint "module.cassandra.aws_ebs_volume.cassandra_data_volume[0]"

terraform apply
```

### Post Recovery Steps
After the Cassandra node is replaced you will need to perform manual steps to get the node back in cluster.

#### Using the same volume
If you attached the same volume to the new instance, you need to follow the these steps before starting Cassandra.

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

#### Modify Cassandra config
You need to modify the file `/etc/cassandra/conf/cassandra-env.sh` to add the line below.

* The IP address should be the same as the node you are replacing, even if the IP happens to be the same as the replacement node.

```
JVM_OPTS="$JVM_OPTS -Dcassandra.replace_address_first_boot=<dead_node_ip>"
```

* Finally you can start the Cassandra service.

```console
sudo systemctl start cassandra
```

# Related Documents

* [How to Expand EBS volumes in AWS](./HowToExpandEBS.md)
* [Drive Mount Script](./DrivemountScript.md)
* [Cassandra Cluster Down Alert](./CassandraClusterDown.md)
* [Cassandra Drive Space Low Alert](./CassandraDriveSpaceLow.md)
* [Cassandra Process Stopped Alert](./CassandraProcessStopped.md)
