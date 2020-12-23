module "scalardl" {
  # source = "git@github.com:scalar-labs/scalar-terraform.git//modules/azure/scalardl?ref=v1.0.0"
  source = "../../../modules/azure/scalardl"

  # Required Variables (Use remote state)
  network   = local.network
  cassandra = local.cassandra

  # Optional Variables
  base = var.base
  scalardl = (local.database == "cosmos" ? merge(var.scalardl, {
    database_contact_points = data.terraform_remote_state.cosmosdb[0].outputs.cosmosdb_account_endpoint
    database_contact_port   = ""
    database_username       = ""
    database_password       = data.terraform_remote_state.cosmosdb[0].outputs.cosmosdb_account_primary_master_key
  }) : var.scalardl)

  envoy = var.envoy
}
