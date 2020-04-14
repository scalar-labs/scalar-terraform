# InstanceDown
This alert indicates that one or more instances are not reporting as being up. The alert will include which instance is being reported as down and the action needed may vary. This alert is not always critical to the overall environment but it could indicate a potential problem if not resolved.  

### Example Alert

#### Firing
```
[prodtest-f4vofpw][FIRING:2] InstanceDown critical
reaper-1.internal.scalar-labs.com:9100 - firing -
scalardl-blue-1.internal.scalar-labs.com:9100 - firing -
```

#### Resolved
```
[prodtest-f4vofpw][RESOLVED] InstanceDown critical
reaper-1.internal.scalar-labs.com:9100 - resolved -
scalardl-blue-1.internal.scalar-labs.com:9100 - resolved -
```

### Actions Needed
* A good place to start is to check the log output for the reported instance to see if it gives a reason why it went down.
* If the instance is not critical you can wait a few minutes to see if it recovers on its own. Most services will restart automatically.
* Check the cloud provider to see if there are any known issues in the deployed location.
  * https://status.azure.com/en-us/status
  * https://status.aws.amazon.com/

### Related Guides
* How to access the [log server](./MonitorGuide.md)
