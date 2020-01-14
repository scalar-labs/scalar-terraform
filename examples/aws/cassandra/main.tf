module "cassandra" {
  #source = "git@github.com:scalar-labs/scalar-terraform.git//modules/aws/cassandra?ref=master"
  source = "../../../modules/aws/cassandra"

  # Required Variables (Use network remote state)
  network = local.network

  # Optional Variables
  base      = var.base
  cassandra = var.cassandra
  cassy     = var.cassy
  reaper    = var.reaper
}
