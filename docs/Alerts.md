## Scalar Alerts
Here you can find the basic information about each alert.

### Critical Alerts
There are two alerts that require immediate attention, they are `CassandraClusterDown` and `ScalarDLClusterDown`. If either of these alerts are `firing` it means that the overall system is unavailable to handle requests.

* [CassandraClusterDown](./CassandraClusterDown.md)
* [ScalarDLClusterDown](./ScalarDLClusterDown.md)

### Warnings
Most alerts that are generated are a warning that help the operator know when to perform a manual task. These tasks could include scaling a cluster up or expanding or clearing drive space. For more information please review each alert page from the menu.

### Alert Structure

#### Title
```
[environment name] [STATE:COUNT] [Alert Name] [critical/warning]
[terratest-vqq0gow][FIRING:1] CassandraProcessStopped warning
```

#### Body
```
[internal-dns-url] - [state (firing/resolved)] - [optional information]
cassandra-2.internal.scalar-labs.com:9100 - firing - /dev/nvme0n1p1 drive has 3.68% free space
** repeated for each alert of this type **
```
