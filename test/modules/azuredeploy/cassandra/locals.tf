locals {
  network = {
    cidr     = data.terraform_remote_state.network.outputs.network_cidr
    name     = data.terraform_remote_state.network.outputs.network_name
    dns      = data.terraform_remote_state.network.outputs.dns_zone_id
    id       = data.terraform_remote_state.network.outputs.network_id
    location = data.terraform_remote_state.network.outputs.location

    subnet_id = data.terraform_remote_state.network.outputs.subnet_map["cassandra"]
    image_id  = data.terraform_remote_state.network.outputs.image_id

    bastion_ip           = data.terraform_remote_state.network.outputs.bastion_ip
    bastion_provision_id = data.terraform_remote_state.network.outputs.bastion_provision_id

    public_key_path   = data.terraform_remote_state.network.outputs.public_key_path
    private_key_path  = data.terraform_remote_state.network.outputs.private_key_path
    user_name         = data.terraform_remote_state.network.outputs.user_name
    internal_root_dns = data.terraform_remote_state.network.outputs.internal_root_dns
  }
}
