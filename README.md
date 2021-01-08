[![AWS Integration Test](https://github.com/scalar-labs/scalar-terraform/workflows/Integration-test-with-terratest-for-AWS/badge.svg?branch=master)](https://github.com/scalar-labs/scalar-terraform/actions)

[![Azure Integration Test](https://github.com/scalar-labs/scalar-terraform/workflows/Integration-test-with-terratest-for-Azure/badge.svg?branch=master)](https://github.com/scalar-labs/scalar-terraform/actions)

# Scalar Terraform: Terraform modules for Scalar DLT orchestration
Scalar Terraform is a set of terraform modules and provisioing scritps that can be used to orchestrate a Scalar DLT network in a cloud. Cloud providers that it currently supports are AWS and Azure. Note that the current version only supports deployment of single Scalar DLT cluster, that is, it does not support multi-cluster Scalar DLT deployment where multiple ledgers are managed independently through Scalar DM.

## Requirements

* [Terraform >= 0.12.x](https://www.terraform.io/downloads.html)
* [Ansible >= 2.8.x](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
* Cloud provider CLI tools such as `aws` and `az` (they need to be configured with credentials)
* Docker Engine (with access to `ghcr.io/scalar-labs/scalar-ledger` docker registry)
  * `scalar-ledger` is available to only our partners and customers at the moment.

## Getting Started

To get started with a simple deployment, please follow [the getting started guide](docs/GettingStarted.md). This guide will cover how to build an environment with the tool.

## Project Overview
The repo is divided into two sections, modules, provision.

#### [Modules](modules)
The modules directory is where the terraform modules are located. The provider section is broken down into cloud specific directories, such as, `aws` or `azure`. There is also one `universal` directory for modules that work across all providers.

#### [Provision](provision)
The provision directory is where Ansible Playbooks are located. The Ansible Playbooks are designed to run on the most common Linux distributions.

## Contributing
This repo is mainly maintained by the Scalar Engineering Team, but of course we appreciate any help.

* For asking questions, finding answers and helping other users, please go to [stackoverflow](https://stackoverflow.com/) and use [scalardl](https://stackoverflow.com/questions/tagged/scalardl) tag.
* For filing bugs, suggesting improvements, or requesting new features, help us out by opening an issue.

## Future Work
* Support multi-cluster deployment
* Support other cloud providers

## License

 A set of modules and scripts in this repository are dual-licensed under both the Apache 2.0 License (found in the LICENSE file in the root directory) and a commercial license. You may select, at your option, one of the above-listed licenses. Regarding the commercial license, please [contact us](https://scalar-labs.com/contact_us/) for more information.
