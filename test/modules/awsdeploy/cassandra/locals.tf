locals {
  integration = {
    cidr     = data.terraform_remote_state.network.outputs.network_cidr
    name     = data.terraform_remote_state.network.outputs.network_name
    dns      = data.terraform_remote_state.network.outputs.network_dns
    id       = data.terraform_remote_state.network.outputs.network_id
    location = data.terraform_remote_state.network.outputs.location

    subnet_id = data.terraform_remote_state.network.outputs.cassandra_subnet_id
    image_id  = data.terraform_remote_state.network.outputs.image_id
    key_name  = data.terraform_remote_state.network.outputs.key_name

    bastion_ip           = data.terraform_remote_state.network.outputs.bastion_ip
    bastion_provision_id = data.terraform_remote_state.network.outputs.bastion_provision_id

    private_key_path  = data.terraform_remote_state.network.outputs.private_key_path
    user_name         = data.terraform_remote_state.network.outputs.user_name
    internal_root_dns = data.terraform_remote_state.network.outputs.internal_root_dns
  }

  unit = {
    cidr     = "10.42.0.0/16"
    name     = "example-aws"
    dns      = "Z08111302BU37G0O8OMMY"
    id       = "vpc-08f36c547a1aca222"
    location = "ap-northeast-1"

    subnet_id = "subnet-0fcdd0a1f75e86b1e"
    image_id  = "ami-0d9d854feeddeef21"
    key_name  = "example-aws-xxxxxxx-key"

    bastion_ip           = "13.231.179.116"
    bastion_provision_id = "9139872180792820156"

    private_key_path  = "../../test.pem"
    user_name         = "centos"
    internal_root_dns = "internal.scalar-labs.com"
  }

  network = var.unit_test ? local.unit : local.integration
}
