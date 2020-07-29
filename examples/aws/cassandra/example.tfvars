region = "ap-northeast-1"

base = "default" # bai, chiku, sho

cassandra = {
  # resource_type                = "t3.large"
  # resource_count               = "3"
  # resource_root_volume_size    = "64"
  # encrypt_volume               = "true"
  # enable_data_volume           = "false"
  # data_use_local_volume        = "false"
  # data_remote_volume_size      = "64"
  # enable_commitlog_volume      = "false"
  # commitlog_use_local_volume   = "false"
  # commitlog_remote_volume_size = "32"
  # memtable_threshold           = "0.33"
  # data_remote_volume_type      = "gp2"
  # commitlog_remote_volume_type = "gp2"
  # enable_tdagent               = "true"
  # start_on_initial_boot        = "false"
}

cassy = {
  # image_tag                 = "1.2.0"
  # resource_type             = "t3.medium"
  # resource_count            = "1"
  # resource_root_volume_size = "64"
  # enable_tdagent            = "true"

  # Required if resource_count > 0
  storage_base_uri = "s3://your-bucket-name"
  storage_type     = "aws_s3"
}

reaper = {
  # resource_type             = "t3.medium"
  # resource_root_volume_size = "64"
  # repliation_factor         = "3"
  # resource_count            = "1"
  # enable_tdagent            = "true"
  # cassandra_username        = ""
  # cassandra_password        = ""
}
