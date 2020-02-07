# ScalarDLClusterDown
This alert indicates that all Scalar DL containers are down and no requests can be processed.  This alert should take the highest priority.  

### Example Alert

#### Firing
```
[prodtest-f4vofpw][FIRING:2] ScalarDLClusterDown critical
- firing -
```

#### Resolved
```
[prodtest-f4vofpw][RESOLVED] ScalarDLClusterDown critical
- resolved -
```

### Action Needed
* Check log server to pinpoint root cause of failure.
* Restart the container with docker-compose.
```
cd provision
docker-compose up -d
```
* Check for ScalarDLContainerDown alerts.  
* Check the cloud provider to see if there are any known issues in the deployed location.
   * https://status.azure.com/en-us/status
   * https://status.aws.amazon.com/

### Related Guide
* How to restart a [docker container](./ContainerGuide.md)
