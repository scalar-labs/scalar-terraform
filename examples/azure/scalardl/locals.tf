locals {
  network = {
    cidr      = data.terraform_remote_state.network.outputs.network_cidr
    name      = data.terraform_remote_state.network.outputs.network_name
    dns       = data.terraform_remote_state.network.outputs.dns_zone_id
    id        = data.terraform_remote_state.network.outputs.network_id
    region    = data.terraform_remote_state.network.outputs.region
    locations = join(",", data.terraform_remote_state.network.outputs.locations)

    image_id = data.terraform_remote_state.network.outputs.image_id

    bastion_ip           = data.terraform_remote_state.network.outputs.bastion_ip
    bastion_provision_id = data.terraform_remote_state.network.outputs.bastion_provision_id

    public_key_path  = data.terraform_remote_state.network.outputs.public_key_path
    private_key_path = data.terraform_remote_state.network.outputs.private_key_path
    user_name        = data.terraform_remote_state.network.outputs.user_name
    internal_domain  = data.terraform_remote_state.network.outputs.internal_domain

    public_subnet_id  = data.terraform_remote_state.network.outputs.subnet_map["public"]
    private_subnet_id = data.terraform_remote_state.network.outputs.subnet_map["private"]
    blue_subnet_id    = data.terraform_remote_state.network.outputs.subnet_map["scalardl_blue"]
    green_subnet_id   = data.terraform_remote_state.network.outputs.subnet_map["scalardl_green"]
  }

  database = lookup(var.scalardl, "database", "cassandra")

  cassandra = {
    start_on_initial_boot = local.database == "cassandra" ? data.terraform_remote_state.cassandra[0].outputs.cassandra_start_on_initial_boot : false
    provision_ids         = local.database == "cassandra" ? join(",", data.terraform_remote_state.cassandra[0].outputs.cassandra_provision_ids) : ""
  }

  scalardl = (local.database == "cosmos" ? merge(var.scalardl, {
    database_contact_points = data.terraform_remote_state.cosmosdb[0].outputs.cosmosdb_account_endpoint
    database_contact_port   = 1
    database_username       = ""
    database_password       = data.terraform_remote_state.cosmosdb[0].outputs.cosmosdb_account_primary_master_key
  }) : var.scalardl)
}
