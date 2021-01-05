# Getting Started
This guide will cover how to use the Scalar DL Orchestration tools to build an environment.

## Install the Requirements

### Terraform
* Terraform install instructions can be found here: https://www.terraform.io/downloads.html
* Please use Terraform 0.12.x

#### OSX
* brew
```console
brew install terraform
```
* [tfenv](https://github.com/tfutils/tfenv)
```console
brew install tfenv
tfenv install 0.12.x
```
NOTE: Please replace `x` with the version you would like to use.

#### Linux
```console
wget https://releases.hashicorp.com/terraform/0.12.8/terraform_0.12.8_linux_amd64.zip
unzip terraform_0.12.8_linux_amd64.zip
sudo cp terraform /usr/local/bin/
```

### Ansible
* Ansible install instructions can be found here: https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html

#### PIP Install
```console
pip install --user ansible
```

### Docker
* Docker install instructions can be found here: https://docs.docker.com/install/

#### Post Install Steps (Make sure you connect to GitHub Container Registry)
```console
docker login ghcr.io
```

### AWS CLI (If using AWS)
* AWS CLI install instructions can be found here: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html#install-tool-pip

```console
pip3 install awscli --upgrade --user
aws configure
```

### Azure CLI (If using Azure)
* Azure CLI install instructions can be found here: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest

#### Post Install Steps
```console
az login
```

## Setting up workspace

### [AWS Scalar DL Example](https://github.com/scalar-labs/scalar-terraform-examples/blob/master/aws/README.md)

### [Azure Scalar DL Example](https://github.com/scalar-labs/scalar-terraform-examples/blob/master/azure/README.md)

## Next Steps

* How to operate a [Cassandra Cluster](./CassandraOperation.md)
* How to do [blue/green deployment](./BlueGreenDeploy.md)
