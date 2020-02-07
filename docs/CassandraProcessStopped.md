# CassandraProcessStopped
This alert indicates that one or more Cassandra processes are not running. This alert alone is not critical but it should be a high priority to resolve.  

### Example Alert

#### Firing
```
[prodtest-f4vofpw][FIRING:1] CassandraProcessStopped warning
cassandra-1.internal.scalar-labs.com:9100 - firing -
```

#### Resolved
```
[prodtest-f4vofpw][RESOLVED] CassandraProcessStopped warning
cassandra-1.internal.scalar-labs.com:9100 - resolved
```

### Action Needed
* It is best to check Cassandra logs first to see if anything was reported.
* A service restart command can be issued on the instance.
```
sudo systemctl restart cassandra
```

### Related Guide
* How to manage a [cassandra cluster](./CassandraGuide.md)
