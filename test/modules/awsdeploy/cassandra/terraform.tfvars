region = "us-east-1"

cassandra = {
  start_on_initial_boot = true
}

cassy = {
  resource_root_volume_size = 16
  storage_base_uri          = "s3://scalar-terraform-test"
  storage_type              = "aws_s3"
}
