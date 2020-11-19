# GrafanaContainerDown

This alert indicates that the Grafana container is not running. This alert is not critical as it won't directly impact the production environment.

### Example Alert

#### Firing

```
[prodtest-f4vofpw][FIRING:2] GrafanaContainerDown warning
reaper-1.internal.scalar-labs.com:18080 - firing -
```

#### Resolved

```
[prodtest-f4vofpw][RESOLVED] GrafanaContainerDown warning
reaper-1.internal.scalar-labs.com:18080 - resolved
```

### Action Needed

* In many cases no action is needed as the container will auto restart. However, you should check logs to see if anything was reported.
* Restart the container with docker-compose.

```console
cd provision
docker-compose up -d
```
