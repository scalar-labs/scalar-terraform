locals {
  network = {
    cidr = data.terraform_remote_state.network.outputs.network_cidr
    name = data.terraform_remote_state.network.outputs.network_name
    dns  = data.terraform_remote_state.network.outputs.network_dns
    id   = data.terraform_remote_state.network.outputs.network_id

    locations  = join(",", data.terraform_remote_state.network.outputs.locations)
    subnet_ids = join(",", data.terraform_remote_state.network.outputs.subnet_map["pulsar"])
    image_id   = data.terraform_remote_state.network.outputs.image_id
    key_name   = data.terraform_remote_state.network.outputs.key_name

    internal_domain = data.terraform_remote_state.network.outputs.internal_domain

  }
}
