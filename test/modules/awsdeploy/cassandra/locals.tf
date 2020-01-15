locals {
  network = {
    cidr     = var.unit_test ? "10.42.0.0/16" : data.terraform_remote_state.network.outputs.network_cidr
    name     = var.unit_test ? "example-aws" : data.terraform_remote_state.network.outputs.network_name
    dns      = var.unit_test ? "Z08111302BU37G0O8OMMY" : data.terraform_remote_state.network.outputs.network_dns
    id       = var.unit_test ? "vpc-08f36c547a1aca222" : data.terraform_remote_state.network.outputs.network_id
    location = var.unit_test ? "ap-northeast-1" : data.terraform_remote_state.network.outputs.location

    subnet_id = var.unit_test ? "subnet-0fcdd0a1f75e86b1e" : data.terraform_remote_state.network.outputs.cassandra_subnet_id
    image_id  = var.unit_test ? "ami-0d9d854feeddeef21" : data.terraform_remote_state.network.outputs.image_id
    key_name  = var.unit_test ? "example-aws-xxxxxxx-key" : data.terraform_remote_state.network.outputs.key_name

    bastion_ip           = var.unit_test ? "13.231.179.116" : data.terraform_remote_state.network.outputs.bastion_ip
    bastion_provision_id = var.unit_test ? "9139872180792820156" : data.terraform_remote_state.network.outputs.bastion_provision_id

    private_key_path  = var.unit_test ? "../../test.pem" : data.terraform_remote_state.network.outputs.private_key_path
    user_name         = var.unit_test ? "centos" : data.terraform_remote_state.network.outputs.user_name
    internal_root_dns = var.unit_test ? "internal.scalar-labs.com" : data.terraform_remote_state.network.outputs.internal_root_dns
  }
}
