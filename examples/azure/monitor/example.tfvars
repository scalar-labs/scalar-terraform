base = "default" # bai, chiku, sho

monitor = {
  resource_type                 = "Standard_D2s_v3"
  # resource_root_volume_size     = "64"
  # resource_count                = "1"
  # active_offset                 = "0"
  # enable_log_volume             = "true"
  # log_volume_size               = "500"
  # log_volume_type               = "Standard_LRS"
  # enable_tdagent                = "true"
  # set_public_access             = "false"
  # remote_port                   = 9090
  # enable_accelerated_networking = "false"
  # log_retention_period_days     = "30"
  log_archive_storage_base_uri  = "https://teiarchive.blob.core.windows.net/test"
}

# targets = [
#   "cassandra",
#   "scalardl",
# ]

#slack_webhook_url = ""
