# ScalarDLContainerDown
This alert indicates that one or more Scalar DL containers are down, but requests can still be processed. This alert alone is not critical but it should take a high priority.

### Example Alert

#### Firing
```
[prodtest-f4vofpw][FIRING:2] ScalarDLContainerDown warning
scalardl-blue-2.internal.scalar-labs.com:18080 - firing -
scalardl-blue-3.internal.scalar-labs.com:18080 - firing -
```

#### Resolved
```
[prodtest-f4vofpw][RESOLVED] ScalarDLContainerDown warning
scalardl-blue-2.internal.scalar-labs.com:18080 - resolved
scalardl-blue-3.internal.scalar-labs.com:18080 - resolved
```

### Action Needed
* In many cases no action is needed as the container will auto restart. However, you should check logs to see if anything was reported.
* Restart the container with docker-compose.
```
cd provision
docker-compose up -d
```

### Related Guide
* How to restart a [docker container](./ContainerGuide.md)
