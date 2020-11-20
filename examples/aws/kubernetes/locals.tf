locals {
  network = {
    cidr   = data.terraform_remote_state.network.outputs.network_cidr
    name   = data.terraform_remote_state.network.outputs.network_name
    id     = data.terraform_remote_state.network.outputs.network_id
    region = data.terraform_remote_state.network.outputs.region

    public_subnet_ids  = join(",", data.terraform_remote_state.network.outputs.subnet_map["public"])
    private_subnet_ids = join(",", data.terraform_remote_state.network.outputs.subnet_map["private"])
    subnet_ids         = join(",", data.terraform_remote_state.network.outputs.subnet_map["kubernetes"])
  }

  custom_tags = data.terraform_remote_state.network.outputs.custom_tags
}
