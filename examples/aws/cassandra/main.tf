module "cassandra" {
  #source = "git@github.com:scalar-labs/scalardl-terraform.git//modules/aws/cassandra?ref=master"

  source = "../../../modules/aws/cassandra"

  # remote state vars
  network = local.network

  base      = var.base
  cassandra = var.cassandra
  cassy     = var.cassy
  reaper    = var.reaper
}
