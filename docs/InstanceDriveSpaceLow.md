# InstanceDriveSpaceLow
This alert indicates that one or more instances have a low drive space for the operating system. This alert is different from the Cassandra drive space alert due to the differences in actions needed.

### Example Alert

#### Firing
```
[prodtest-f4vofpw][FIRING:1] InstanceDriveSpaceLow warning
scalar-blue-2.internal.scalar-labs.com:9100 - firing - /dev/nvme0n1p1 drive has 3.68% free space
```

#### Resolved
```
[prodtest-f4vofpw][RESOLVED] InstanceDriveSpaceLow warning
scalar-blue-2.internal.scalar-labs.com:9100 - resolved
```

### Action Needed
* Connect to the reported instance and local large directories. Clear space as needed.
```console
du --max-depth=1 /path | sort -r -k1,1n
```
* If for some reason the docker container size is growing, in most cases it is safe to remove and restart the container.
* Expand the disk size. This option varies depending on cloud provider and it is best to check the provider specific documents.  

### Related Guide
* How to access [backend instance](./SSHGuide.md)
