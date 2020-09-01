# How to share environments with others

Non-testing environments tend to be shared and operated with multiple DevOps engineers.
This document explains how to do it properly.

## Get a private key from the person who has built an environment.

You can generate a corresponding public key with `ssh-keygen -yf ~/.ssh/privatekey.pem > publickey.pem`.

If an environment is created with `local` backend, you need all the tfstate files additionally. But, as a best practice, it's better to use cloud storage backends such as AWS S3 or Azure Blob Storage for an environment that is shared among multiple engineers.

## Update the tfstate of the network module

Update the key paths of `tfvars` file in your local such as `example.tfvars` in the example.

```
public_key_path = "./publickey.pem"

private_key_path = "./privatekey.pem"
```

Then, update tfstate file as follows.

```
cd /path/to/network
terraform init
terraform refresh -var-file=example.tfvars
```

## Update the tfstate of the cassandra, scalardl, and monitor modules

Update the values of `private_key_path` and `public_key_path` of `data.terraform_remote_state.network` in each tfstate and do as follows.

```
cd /path/to/[cassandra|scalardl|monitor]
terraform init
terraform refresh -var-file=example.tfvars
```
