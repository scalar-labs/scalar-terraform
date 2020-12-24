# Azure Scalar DL Example
This example will deploy a simple Scalar DL environment in the Japaneast region with your Azure account. If you want to use another region or store the tfstate on Azure you need to update `backend.tf`, `examples.tfvars` and `remote.tf` of each module.

* This document is for internal use of Scalar DL Terraform modules for Azure. If you are interested in the modules please take a look at [here](../../modules/azure)

## Prerequisites
* Terraform >= 0.12.x
* Ansible >= 2.8.x
* Azure CLI
* ssh-agent with private key

## What is created
* An Azure VPC with Resource Group
* DNS Zone for internal host lookup
* 3 Scalar DL instances
* 3 Cassandra instances
* 1 Cassy instance
* 1 Reaper instance
* 3 Envoy instances with a network load balancer (public)
* 1 Bastion instance with a public IP
* 1 Monitor instance

## How to deploy

### Configure an Azure credential

```console
$ az login
```

### Create network resources

```console
$ cd examples/azure/network

# Generate a test key-pair
$ ssh-keygen -b 2048 -t rsa -f ./example_key -q -N ""
$ chmod 400 example_key

# You need to pass the key to your ssh agent
# If needed start ssh-agent using: eval $(ssh-agent -s)
$ ssh-add example_key

# Optionally, you may want to create a file named `additional_public_keys` that contains multiple ssh public keys (one key per line) to allow other admins to access nodes created by the following `terraform apply`.
# the file should look like below
# cat examples/azure/network/additional_public_keys
# ssh-rsa AAAAB3Nza..... admin1
# ssh-rsa...... admin2


# Create an environment
$ terraform init
$ terraform apply -var-file example.tfvars
```

### Create database resources

This example supports two database options: Cassandra and Cosmos DB.

#### Cassandra

Before creating Cassandra resources with `terraform apply`, you probably need to configure for Cassy to manage backups of Cassandra data. 

The first thing you need to do for Cassy is create a storage account in the same resource group as the network resource created in the previous section and create a blob type container in the storage account.

Then, update `example.tfvars` with the container URL as follows.

```
cassy = {
  storage_base_uri     = "https://yourstorageaccountname.blob.core.windows.net/your-container-name"
  storage_type         = "azure_blob"
}
```

If you don't need Cassy, you can disable it by setting its `resource_count` to zero.

```
cassy = {
  resource_count = 0
}
```

For more information on Cassy, please refer to [CassySetup](../../docs/CassySetup.md).

Now it's ready to run the terraform commands:

```console
$ cd examples/azure/cassandra

$ terraform init
$ terraform apply -var-file example.tfvars
```

Please make sure to start all the Cassandra nodes since Cassandra doesn't start on the initial boot by default.

#### Cosmos DB

To create a Cosmos DB account on your Azure account, please just run the follwoing command.

```console
$ cd examples/azure/cosmosdb
$ terraform apply
```

### Create Scalar DL resources

If you chose Cosmos DB, please uncomment the following line in `examples/azure/scalardl/example.tfvars`.
The information needed to connect to the Cosmos DB is fetched from the state in `examples/azure/cosmosdb`.

```terraform
  # database = "cosmos"
```

If you use Cassandra, you don't have to update the tfvars file unless you have changed the credentials or other information.

```console
$ cd examples/azure/scalardl

$ terraform init
$ terraform apply -var-file example.tfvars
```

### Create Monitor resources

```console
$ cd examples/azure/monitor

$ terraform init
$ terraform apply -var-file example.tfvars
```

## Generate outputs
Terraform can output some useful information about your deployment such as a bastion public, internal ip addresses and ssh config that you can use to access instances. The ssh config assumes that the private key for an environment is added to your ssh agent.

### Network

```
$ terraform output
ssh_config = Host *
User centos
UserKnownHostsFile /dev/null
StrictHostKeyChecking no

Host bastion
HostName bastion-tei-azure-1rpvoeq.westus.cloudapp.azure.com
LocalForward 8000 monitor.internal.scalar-labs.com:80

Host *.internal.scalar-labs.com
ProxyCommand ssh -F ssh.cfg bastion -W %h:%p

bastion_ip = bastion-tei-azure-1rpvoeq.westus.cloudapp.azure.com
bastion_provision_id = 4163659894346351826
dns_zone_id = internal.scalar-labs.com
image_id = CentOS
internal_domain = internal.scalar-labs.com
location = West US
network_cidr = 10.42.0.0/16
network_id = /subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/tei-azure-1rpvoeq/providers/Microsoft.Network/virtualNetworks/tei-azure-1rpvoeq
network_name = tei-azure-1rpvoeq
private_key_path = /Users/tei/work/src/scalar/scalar-terraform-release/examples/azure/network/example_key
public_key_path = /Users/tei/work/src/scalar/scalar-terraform-release/examples/azure/network/example_key.pub
subnet_map = {
  "cassandra" = "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/tei-azure-1rpvoeq/providers/Microsoft.Network/virtualNetworks/tei-azure-1rpvoeq/subnets/cassandra"
  "private" = "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/tei-azure-1rpvoeq/providers/Microsoft.Network/virtualNetworks/tei-azure-1rpvoeq/subnets/private"
  "public" = "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/tei-azure-1rpvoeq/providers/Microsoft.Network/virtualNetworks/tei-azure-1rpvoeq/subnets/public"
  "scalardl_blue" = "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/tei-azure-1rpvoeq/providers/Microsoft.Network/virtualNetworks/tei-azure-1rpvoeq/subnets/scalardl_blue"
  "scalardl_green" = "/subscriptions/xxxxxxxx-xxxx-xxxx-xxxx-xxxxxxxxxxxx/resourceGroups/tei-azure-1rpvoeq/providers/Microsoft.Network/virtualNetworks/tei-azure-1rpvoeq/subnets/scalardl_green"
}
user_name = centos
```

### Cassandra

```
$ terraform output
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

$ ssh -F ssh.cfg cassy-1.internal.scalar-labs.com
$ ssh -F ssh.cfg reaper-1.internal.scalar-labs.com

$ ssh -F ssh.cfg envoy-1.internal.scalar-labs.com
$ ssh -F ssh.cfg envoy-2.internal.scalar-labs.com
$ ssh -F ssh.cfg envoy-3.internal.scalar-labs.com

$ ssh -F ssh.cfg monitor-1.internal.scalar-labs.com
```

## How to destroy

```console
# Make sure to do this after used !!!
$ terraform destroy --var-file example.tfvars
```

Note: Don't forget to `terraform destroy` to the environment you created after used.

Please check out [Scalar DL Getting Started](https://scalardl.readthedocs.io/en/latest/getting-started/) to understand how to interact with the environment.
