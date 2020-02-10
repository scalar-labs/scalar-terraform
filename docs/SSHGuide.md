# SSH to backend
When you deploy a Scalar environment you need to provide a public/private key-pair. This key-pair will be used to tunnel a connection to the monitoring system.

* It is assumed that the private key is loaded into an ssh-agent.
```
ssh-add ~/.ssh/mykey.pem
```

## Generate SSH Config
* One of the terraform outputs is an ssh config file.

```
terraform output ssh_config > ssh.cfg

ssh -F ssh.cfg resource-name-[1-3].internal.scalar-labs.com
```

## Access Cassandra
```
ssh -F ssh.cfg cassandra-1.internal.scalar-labs.com

cqlsh cassandra-1.internal.scalar-labs.com
```

## Access Scalar DL
```
ssh -F ssh.cfg scalar-blue-1.internal.scalar-labs.com
ssh -F ssh.cfg scalar-green-1.internal.scalar-labs.com

docker ps
```

## Access Envoy Proxy
```
ssh -F ssh.cfg envoy-1.internal.scalar-labs.com

docker ps
```

## Access Reaper
```
ssh -F ssh.cfg -L 8080:localhost:8080 reaper.internal.scalar-labs.com
```

http://localhost:8080/webui/index.html

## Access Logs (Monitor Resource)
```
ssh -F ssh.cfg monitor.internal.scalar-labs.com

cd /var/log/tdagent
```

* [How to access the monitor server](./MonitorGuide.md)

## Bastion
```
ssh -A centos@bastion_ip

ssh ip/dns of backend
```
