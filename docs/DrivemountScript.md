# Drive Mount Script
The drive mount script will format and mount the Data and Commitlog volumes on the Cassandra hosts.

### Why it is needed?
* AWS EBS volumes are not always attached to an instance in the same order which makes it difficult to assign the EBS volume.

### Lookup Command
```console
lsblk -p -P -d -o name,serial,UUID,HCTL
```

* On AWS `serial` references the EBS Volume ID
* On Azure `HCTL` references the logic drive number

### AWS Case
The following environment variables are set when the instance is created. The script will match these values to the `serial` value from the lookup command.

```
DATA_STORE=<EBS Volume ID> or local
COMMIT_STORE=<EBS Volume ID> or local
```

### Azure Case
The following environment variables are set when the instance is created. These values are the logical drive number set at instance creation time. The script will match these values to the `HCTL` value from the lookup command.

```
DATA_STORE=5 or local
COMMIT_STORE=6 or local
```

### Local NVME Storage
In the case of AWS the local NVME drive needs to be formatted and mounted. The drive has a special `serial` value that starts with `AWSxxx`. To keep things the same between Azure and AWS the local NVME drive is mounted to `/mnt/resources`.

* If there are multiple NVME drives then a logical volume will be created.
* NVME drives are always cleared after a reboot so this script will run at boot up time before the Cassandra process is started.   


### Mount Points
The following mount points are used for Data and Commitlogs. Each directory is `chown` to the `cassandra` user and group.

```console
# For Root Volume or EBS Volume
/data
/commitlog

# For NVME local storage
ln -sf /mnt/resource/data /data
ln -sf /mnt/resource/commitlog /commitlog
```
