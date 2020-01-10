# AWS Scalar DL Example
This example will deploy a simple Scalar DL environment in your AWS account inside the Tokyo region. If you wish to use another region you can modify the `backend.tf` and `examples.tfvars` and `remote.tf` files.

* This Document is for internal use of Scalar DL Terraform modules. If you are interested in managed modules please look [here](../../modules)

### What is required?
* Terraform >= 0.12.x
* Ansible 2.8
* AWS CLI
* ssh-agent with private key

### What is created?
* AWS VPC with NAT gateway
* DNS Zone for internal host lookup
* 3 Scalar DL instances with a network load balancer (private)
* 3 Cassandra instances with a network load balancer (private)
* 1 Cassy instance
* 1 Reaper instance
* 3 Envoy instances with a network load balancer (public)
* 1 Bastion instance with a public IP

### How to deploy?

#### AWS Credentials

```Shell
# In this example you will need AWS cli configured with a profile
$ aws configure --profile scalar
```

#### Create Network resources


```shell
$ cd examples/aws/network

# Generate a test key-pair
$ ssh-keygen -b 2048 -t rsa -f ./example_key -q -N ""
$ chmod 400 example_key

# You need to pass the key to your ssh agent
# If needed start ssh-agent using: eval $(ssh-agent -s)
$ ssh-add example_key

# Start Environment
$ terraform init
$ terraform apply -var-file example.tfvars
```

#### Create Cassandra resources

```shell
$ cd examples/aws/cassandra

$ terraform init
$ terraform apply -var-file example.tfvars
```

#### Create ScalarDL resources

```shell
$ cd examples/aws/scalardl

$ terraform init
$ terraform apply -var-file example.tfvars
```

#### Create Monitor resources

```shell
$ cd examples/aws/monitor

$ terraform init
$ terraform apply -var-file example.tfvars
```

### How to Destroy?

```shell
# After Testing !!Destroy Environment!!
$ terraform destroy --var-file examples.tfvars
```
Note: Don't forget to `terraform destroy` your environment after you are done.

Be sure to checkout the [Scalar DL Getting Started](https://scalardl.readthedocs.io/en/latest/getting-started/) to understand how to use your environment.  

### Example Output
Terraform will output some useful information about your deployment, such as the bastion public and internal ip addresses. If you want to access your resources you can use the private key generated before.

#### Network
```
Outputs:

ssh_config = Host *
User centos
UserKnownHostsFile /dev/null
StrictHostKeyChecking no

Host bastion
HostName 13.231.214.169
LocalForward 8000 monitor.internal.scalar-labs.com:80

Host *.internal.scalar-labs.com
ProxyCommand ssh -F ssh.cfg bastion -W %h:%p

bastion_ip = [
    13.231.214.169
]
```

#### Cassandra
```
Outputs:

cassandra_ip = [
    10.42.2.94,
    10.42.2.213,
    10.42.2.206
]
```

#### Scalar DL
```
outputs:

scalardl_blue_ip = [
    10.42.3.222,
    10.42.3.248,
    10.42.3.101
]
scalardl_green_ip = []
```

#### Monitor
Note: No outputs.

### How to access backend resources

```Shell
# SSH with ssh-agent
$ ssh -A centos@13.231.214.169

# Generate SSH config to make it easy to access backend resources
$ terraform output "ssh_config" > ssh.cfg
$ ssh -F ssh.cfg cassandra-1.internal.scalar-labs.com
$ ssh -F ssh.cfg cassandra-2.internal.scalar-labs.com
$ ssh -F ssh.cfg cassandra-3.internal.scalar-labs.com

$ ssh -F ssh.cfg scalar-blue-1.internal.scalar-labs.com
$ ssh -F ssh.cfg scalar-blue-2.internal.scalar-labs.com
$ ssh -F ssh.cfg scalar-blue-3.internal.scalar-labs.com

$ ssh -F ssh.cfg cassy.internal.scalar-labs.com
$ ssh -F ssh.cfg reaper.internal.scalar-labs.com

$ ssh -F ssh.cfg envoy-1.internal.scalar-labs.com
$ ssh -F ssh.cfg envoy-2.internal.scalar-labs.com
$ ssh -F ssh.cfg envoy-3.internal.scalar-labs.com

$ ssh -F ssh.cfg monitor.internal.scalar-labs.com
```
