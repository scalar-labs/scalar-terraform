locals {
  network = {
    network_cidr = data.terraform_remote_state.network.outputs.network_cidr
    network_name = data.terraform_remote_state.network.outputs.network_name
    network_dns  = data.terraform_remote_state.network.outputs.network_dns
    network_id   = data.terraform_remote_state.network.outputs.network_id
    location     = data.terraform_remote_state.network.outputs.location

    subnet_id = data.terraform_remote_state.network.outputs.cassandra_subnet_id
    image_id  = data.terraform_remote_state.network.outputs.image_id
    triggers  = [data.terraform_remote_state.network.outputs.bastion_provision_id]

    key_name   = data.terraform_remote_state.network.outputs.key_name
    bastion_ip = data.terraform_remote_state.network.outputs.bastion_ip

    private_key_path = data.terraform_remote_state.network.outputs.private_key_path
    user_name        = data.terraform_remote_state.network.outputs.user_name
  }
}
