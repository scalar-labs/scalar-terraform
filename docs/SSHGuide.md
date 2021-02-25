# SSH to backend
When you deploy a Scalar environment you need to provide a public/private key-pair. This key-pair will be used to tunnel a connection to the monitoring system.

* It is assumed that the private key is loaded into an ssh-agent.
```console
ssh-add ~/.ssh/mykey.pem
```

## Generate SSH Config
* One of the terraform outputs is an ssh config file.

```console
terraform output -raw ssh_config > ssh.cfg

ssh -F ssh.cfg resource-name-[1-3].internal.scalar-labs.com
```

## Access Cassandra
```console
ssh -F ssh.cfg cassandra-1.internal.scalar-labs.com

cqlsh -u cassandra -p cassandra cassandra-1.internal.scalar-labs.com
```

## Access Scalar DL
```console
ssh -F ssh.cfg scalardl-blue-1.internal.scalar-labs.com
ssh -F ssh.cfg scalardl-green-1.internal.scalar-labs.com

docker ps
```

## Access Envoy Proxy
```console
ssh -F ssh.cfg envoy-1.internal.scalar-labs.com

docker ps
```

## Access Reaper
```console
ssh -F ssh.cfg -L 8080:localhost:8080 reaper-1.internal.scalar-labs.com
```

http://localhost:8080/webui/index.html

## Access Logs (Monitor Resource)
```console
ssh -F ssh.cfg monitor-1.internal.scalar-labs.com

cd /var/log/tdagent
```

* [How to access the monitor server](./MonitorGuide.md)

## Bastion
```console
ssh -A centos@bastion_ip

ssh ip/dns of backend
```
