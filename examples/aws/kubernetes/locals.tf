locals {
  network = {
    cidr   = data.terraform_remote_state.network.outputs.network_cidr
    name   = data.terraform_remote_state.network.outputs.network_name
    id     = data.terraform_remote_state.network.outputs.network_id
    region = data.terraform_remote_state.network.outputs.region

    public_subnet_ids  = join(",", data.terraform_remote_state.network.outputs.subnet_map["public"])
    private_subnet_ids = join(",", data.terraform_remote_state.network.outputs.subnet_map["private"])
    subnet_ids         = join(",", data.terraform_remote_state.network.outputs.subnet_map["kubernetes"])

    bastion_ip      = data.terraform_remote_state.network.outputs.bastion_ip
    user_name       = data.terraform_remote_state.network.outputs.user_name
    internal_domain = data.terraform_remote_state.network.outputs.internal_domain
  }

  custom_tags = data.terraform_remote_state.network.outputs.custom_tags
}
