module "cosmosdb" {
  # source = "git@github.com:scalar-labs/scalar-terraform.git//modules/azure/cosmosdb?ref=v1.0.0"
  source = "../../../modules/azure/cosmosdb"

  # Required Variables
  network    = local.network
  kubernetes = local.kubernetes

  # Optional Variables
  base     = var.base
  cosmosdb = var.cosmosdb
}
