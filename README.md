[![AWS-Terratest](https://github.com/scalar-labs/scalar-terraform/workflows/Integration%20test%20with%20terratest%20for%20AWS/badge.svg?branch=master)](https://github.com/scalar-labs/scalar-terraform/actions)
[![Azure-Terratest](https://github.com/scalar-labs/scalar-terraform/workflows/Integration%20test%20with%20terratest%20for%20Azure/badge.svg?branch=master)](https://github.com/scalar-labs/scalar-terraform/actions)

# Terraform modules for Scalar DL orchestration
This repo is a set of terraform modules that can be used to build a Scalar DL environment.

## Requirements

* [Terraform >= 0.12.x](https://www.terraform.io/downloads.html)
* [Ansible >= 2.8.x](https://docs.ansible.com/ansible/latest/installation_guide/intro_installation.html)
* AWS/Azure (Cloud provider CLI tool configured with credentials)
* Docker Engine (with access to `scalarlabs/scalar-ledger` docker registry)

## Getting Started

To get started with a simple deployment, please follow [the getting started guide](docs/GettingStarted.md). This guide will cover how to build an environment with the tool.

## Project Overview
The repo is divided into two sections, modules, provision.

#### [Modules](modules)
The modules directory is where the terraform modules are located. The provider section is broken down into cloud specific directories, such as, `aws` or `azure`. There is also one `universal` directory for modules that work across all providers.

#### [Provision](provision)
The provision directory is where Ansible Playbooks are located. Ansible is used for provisioning the host resource with the required software. The Ansible Playbooks are designed to run on the most common Linux distributions.
