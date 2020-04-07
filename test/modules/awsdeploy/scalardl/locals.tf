locals {
  network = {
    cidr      = data.terraform_remote_state.network.outputs.network_cidr
    name      = data.terraform_remote_state.network.outputs.network_name
    dns       = data.terraform_remote_state.network.outputs.network_dns
    id        = data.terraform_remote_state.network.outputs.network_id
    locations = join(",", data.terraform_remote_state.network.outputs.locations)

    image_id = data.terraform_remote_state.network.outputs.image_id
    key_name = data.terraform_remote_state.network.outputs.key_name

    bastion_ip           = data.terraform_remote_state.network.outputs.bastion_ip
    bastion_provision_id = data.terraform_remote_state.network.outputs.bastion_provision_id

    private_key_path = data.terraform_remote_state.network.outputs.private_key_path
    user_name        = data.terraform_remote_state.network.outputs.user_name
    internal_domain  = data.terraform_remote_state.network.outputs.internal_domain

    public_subnet_ids  = join(",", data.terraform_remote_state.network.outputs.subnet_map["public"])
    private_subnet_ids = join(",", data.terraform_remote_state.network.outputs.subnet_map["private"])
    blue_subnet_ids    = join(",", data.terraform_remote_state.network.outputs.subnet_map["scalardl_blue"])
    green_subnet_ids   = join(",", data.terraform_remote_state.network.outputs.subnet_map["scalardl_green"])
  }

  cassandra = {
    start_on_initial_boot = data.terraform_remote_state.cassandra.outputs.cassandra_start_on_initial_boot
    provision_ids         = join(",", data.terraform_remote_state.cassandra.outputs.cassandra_provision_ids)
  }
}
