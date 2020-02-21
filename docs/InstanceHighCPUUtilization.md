# InstanceHighCPUUtilization
This alert indicates that one or more instances have an average CPU usage over 90% for the past 5 minutes. In many cases this alert is normal to see during peak operation times, but you might need to scale up the spec if you see this in non-peak operation times. It doesn't reflect the overall state of the environment.

### Example Alert

#### Firing
```
[prodtest-f4vofpw][FIRING:1] InstanceHighCPUUtilization warning
cassandra-1.internal.scalar-labs.com:9100 - firing - 93.93%
```

#### Resolved
```
[prodtest-f4vofpw][RESOLVED] InstanceHighCPUUtilization warning
cassandra-1.internal.scalar-labs.com:9100 - resolved
```

### Action Needed
* Keep an eye on Grafana dashboard (Scalar DLT Response) and check for high response times in the 99th, 95th, and 90th percentile. This may indicate the cluster needs to be expanded or a bigger resource type is needed.

### Related Guide
* How to access the [monitor server](./MonitorGuide.md)
