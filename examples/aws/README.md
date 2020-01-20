# AWS Scalar DL Example
This example will deploy a simple Scalar DL environment in the Tokyo region with your AWS account. If you want to use another region or store the tfstate on S3 you need to update `backend.tf`, `examples.tfvars` and `remote.tf` of each module.

* This document is for internal use of Scalar DL Terraform modules for AWS. If you are interested in the modules please take a look at [here](../../modules/aws)

## Prerequisites
* Terraform >= 0.12.x
* Ansible 2.8
* AWS CLI
* ssh-agent with private key

## What is created
* An AWS VPC with a NAT gateway
* DNS Zone for internal host lookup
* 3 Scalar DL instances with a network load balancer (private)
* 3 Cassandra instances with a network load balancer (private)
* 1 Cassy instance
* 1 Reaper instance
* 3 Envoy instances with a network load balancer (public)
* 1 Bastion instance with a public IP
* 1 Monitor instance

## How to deploy

### Configure an AWS credential

```console
# In this example you need AWS cli configured with `scalar` profile
$ aws configure --profile scalar
```

### Create network resources

```console
$ cd examples/aws/network

# Generate a test key-pair
$ ssh-keygen -b 2048 -t rsa -f ./example_key -q -N ""
$ chmod 400 example_key

# You need to pass the key to your ssh agent
# If needed start ssh-agent using: eval $(ssh-agent -s)
$ ssh-add example_key

# Create an environment
$ terraform init
$ terraform apply -var-file example.tfvars
```

### Create Cassandra resources

```console
$ cd examples/aws/cassandra

$ terraform init
$ terraform apply -var-file example.tfvars
```

### Create Scalar DL resources

```console
$ cd examples/aws/scalardl

$ terraform init
$ terraform apply -var-file example.tfvars
```

### Create Monitor resources

```console
$ cd examples/aws/monitor

$ terraform init
$ terraform apply -var-file example.tfvars
```

## Generate outputs
Terraform can output some useful information about your deployment such as a bastion public, internal ip addresses and ssh config that you can use to access instances. The ssh config assumes that the private key for an environment is added to your ssh agent.

### Network

```
$ terraform output
--- Output is displayed here ---

Outputs:

ssh_config = Host *
User centos
UserKnownHostsFile /dev/null
StrictHostKeyChecking no

Host bastion
HostName 13.231.179.116
LocalForward 8000 monitor.internal.scalar-labs.com:80

Host *.internal.scalar-labs.com
ProxyCommand ssh -F ssh.cfg bastion -W %h:%p

bastion_ip = 13.231.179.116
bastion_provision_id = 9139872180792820156
cassandra_subnet_id = subnet-0fcdd0a1f75e86b1e
image_id = ami-0d9d854feeddeef21
internal_root_dns = internal.scalar-labs.com
key_name = tei-aws-0j5y83k-key
location = ap-northeast-1a
network_cidr = 10.42.0.0/16
network_dns = Z08111302BU37G0O8OMMY
network_id = vpc-08f36c547a1aca222
network_name = tei-aws-0j5y83k
private_key_path = /Users/tei/work/src/scalar-terraform/examples/aws/network/your_private.pem
scalardl_blue_subnet_id = subnet-04e9f97893fd8e794
scalardl_green_subnet_id = subnet-015ee9afbcf722ec4
scalardl_nlb_subnet_id = subnet-0a88b78eaaf74b16b
user_name = centos
```

### Cassandra
```
$ terraform output
--- Output is displayed here ---

Outputs:

cassandra_provision_ids = [
  "4019088576544490630",
  "656319024837932240",
  "2469094098071954264",
]
cassandra_resource_count = 3
cassandra_start_on_initial_boot = false
```

### Scalar DL
```
$ terraform output
--- Output is displayed here ---

outputs:

scalardl_blue_resource_count = 3
scalardl_green_resource_count = 0
scalardl_replication_factor = 3
```

### Monitor
Note: No outputs.

## How to access instances

```console
# SSH with ssh-agent
$ ssh -A centos@13.231.179.116

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

## How to Destroy

```console
# Make sure to do this after used !!!
$ terraform destroy --var-file example.tfvars
```

Note: Don't forget to `terraform destroy` to the environment you created after used.

Please check out [Scalar DL Getting Started](https://scalardl.readthedocs.io/en/latest/getting-started/) to understand how to interact with the environment.
