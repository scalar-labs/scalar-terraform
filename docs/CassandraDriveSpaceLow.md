# CassandraDriveSpaceLow
This alert indicates that one or more Cassandra instances are reporting low drive space for Cassandra data. This alert should fire when 70% of the drive is in use. This should give the operator enough time to plan the next actions.

### Example Alert

#### Firing
```
[prodtest-f4vofpw][FIRING:1] CassandraDriveSpaceLow critical
cassandra-2.internal.scalar-labs.com:9100 - firing - /dev/nvme0n1p1 drive has 3.68% free space
```

#### Resolved
```
[prodtest-f4vofpw][RESOLVED] CassandraDriveSpaceLow warning
cassandra-2.internal.scalar-labs.com:9100 - resolved
```

### Action Needed
* Connect to the reported instance and local large directories. Check if you can remove any old snapshot.
```
du --max-depth=1 /path | sort -r -k1,1n
```
* Expand the disk size. This option varies depending on cloud provider and it is best to check provider specific documents.
* Expand the Cassandra Cluster to spread data around.  

### Related Guide
* How to access [backend instance](./SSHGuide.md)
