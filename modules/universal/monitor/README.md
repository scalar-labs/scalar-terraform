# Monitor Module

## Prometheus
Prometheus is a monitoring and alerting system.

### DNS Service Discovery
Prometheus discovers services to monitor by the
[`dns_sd_config`](https://prometheus.io/docs/prometheus/latest/configuration/configuration/#dns_sd_config)
(DNS Service Discovery) feature. SRV records in DNS are used by Prometheus to find the host
and port information. The DNS records need to be configured for each cloud provider.

For example, Prometheus looks up the SRV of the name
`_node-exporter._tcp.cassandra.internal.scalar-labs.com` to find the Node
Exporter working on each Cassandra node. If the number of nodes is configured to
3, the value of SRV would be the following:
```
0 0 9100 cassandra-1.internal.scalar-labs.com.
0 0 9100 cassandra-2.internal.scalar-labs.com.
0 0 9100 cassandra-3.internal.scalar-labs.com.
```

9100 is the port that Node Exporter listens to.

Please see the file
`provider/universal/monitor/provision/prometheus/prometheus.yml.j2` to find the
list of DNS names that are used to look up services.

Generally, an SRV record has the form:
```
_<service>._<proto>.<name>. <TTL> IN SRV <priority> <weight> <port> <target>.
```

Here `<priority>` and `<weight>` do not matter for monitoring, so they both can
be any value.

Note: As far as it is used with Prometheus, the name should not necessarily
follow the rule that `_<service>` and `_<proto>` are prefixed by `_`. But in
this module they are following the standard.
