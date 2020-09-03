# How to share environments with others

Non-testing environments tend to be shared and operated with multiple DevOps engineers.
This document explains how to do it properly.
## Why we need the following steps

When we build an environment with scalar-terraform, the paths of a specified key pair are stored in tfstate files. Those paths are expanded to the full paths even if they are specified with relative paths, so the paths can be operator dependent variables unless all the operators agree on the same full paths beforehand.
With the following steps, you actually update tfstate files based on your environment to make it work for you.

Note that if you update shared tfstate files in Cloud storage based on your environment, others can not use the tfstate files and they have to do the same steps again to make it be able to work for them. So, it is more like a delegation of the operator in such case.


## Get a private key from the person who has built an environment.

First of all, please get a private key that is used to build an environment by the person who did it.
You can generate a corresponding public key with `ssh-keygen -yf ~/.ssh/privatekey.pem > publickey.pem`.
Here we assume we have `/path/to/privatekey.pem` and `/path/to/publickey.pub`.

If an environment is created with `local` backend, you need all the tfstate files additionally. But, as a best practice, it's better to use cloud storage backends such as AWS S3 or Azure Blob Storage for an environment that is shared among multiple engineers.

## Update the tfstate of the network module

Update the key paths of `tfvars` file in your local such as `example.tfvars` in the example.

```
public_key_path = "/path/to/publickey.pem"

private_key_path = "/path/to/privatekey.pem"
```

Then, update tfstate file as follows.

```
cd /path/to/network
terraform init
terraform refresh -var-file=example.tfvars
```

## Update the tfstate of the cassandra, scalardl, and monitor modules

Then, do the following to reflect the above changes to each module.

```
cd /path/to/[cassandra|scalardl|monitor]
terraform init
terraform refresh -var-file=example.tfvars
```
