region = "ap-northeast-1"

base = "default" # bai, chiku, sho

bookie = {
  # resource_type             = "i3.xlarge"
  # resource_count            = 3
  # resource_root_volume_size = 64
  # enable_data_volume        = true
  # data_use_local_volume     = false
  # data_remote_volume_size   = 64
  # data_remote_volume_type   = "gp2"
  # enable_tdagent            = true
  # encrypt_volume            = true
}

broker = {
  # resource_type             = "c5.2xlarge"
  # resource_count            = 3
  # resource_root_volume_size = 64
  # enable_tdagent            = true
}

zookeeper = {
  # resource_type             = "t3.small"
  # resource_count            = 3
  # resource_root_volume_size = 64
  # enable_data_volume        = true
  # data_use_local_volume     = false
  # data_remote_volume_size   = 64
  # data_remote_volume_type   = "gp2"
  # enable_tdagent            = true
}
