locals {
  network = {
    cidr = data.terraform_remote_state.network.outputs.network_cidr
    name = data.terraform_remote_state.network.outputs.network_name
    dns  = data.terraform_remote_state.network.outputs.network_dns
    id   = data.terraform_remote_state.network.outputs.network_id

    subnet_ids = join(",", data.terraform_remote_state.network.outputs.subnet_map["private"])
    image_id   = data.terraform_remote_state.network.outputs.image_id
    key_name   = data.terraform_remote_state.network.outputs.key_name

    bastion_ip           = data.terraform_remote_state.network.outputs.bastion_ip
    bastion_provision_id = data.terraform_remote_state.network.outputs.bastion_provision_id

    private_key_path = data.terraform_remote_state.network.outputs.private_key_path
    user_name        = data.terraform_remote_state.network.outputs.user_name
    internal_domain  = data.terraform_remote_state.network.outputs.internal_domain
  }
}
