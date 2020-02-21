# CassandraClusterDown
This is the most critical alert and indicates that the Cassandra cluster is not able to process requests. This alert should be handled with the highest priority.

### Example Alert

#### Firing
```
[prodtest-f4vofpw][FIRING:1] CassandraClusterDown critical
 - firing -
```

#### Resolved
```
[prodtest-f4vofpw][RESOLVED] CassandraClusterDown critical
- resolved -
```

### Action Needed
* Check Cassandra logs see if anything was reported.
* Check for related CassandraProcessStopped alerts.
* A service restart command can be issued on the instances.
```
sudo systemctl restart cassandra
```
* Check the cloud provider to see if there are any known issues in the deployed location.
   * https://status.azure.com/en-us/status
   * https://status.aws.amazon.com/
