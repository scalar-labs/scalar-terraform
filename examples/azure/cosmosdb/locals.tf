locals {
  network = {
    name   = data.terraform_remote_state.network.outputs.network_name
    region = data.terraform_remote_state.network.outputs.region
  }

  allowed_subnet_ids = [
    data.terraform_remote_state.network.outputs.subnet_map["scalardl_blue"],
    data.terraform_remote_state.network.outputs.subnet_map["scalardl_green"]
  ]
}
