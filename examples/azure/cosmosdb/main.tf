module "cosmosdb" {
  # source = "git::https://github.com/scalar-labs/scalar-terraform.git//modules/azure/cosmosdb?ref=master"
  source = "../../../modules/azure/cosmosdb"

  # Required Variables
  network            = local.network
  allowed_subnet_ids = local.allowed_subnet_ids
}
