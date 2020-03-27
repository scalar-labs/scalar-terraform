base = "default" # bai, chiku, sho

scalardl = {
  # resource_type             = "Standard_B2s"
  # resource_root_volume_size = "64"
  # blue_resource_count       = "3"
  # blue_image_tag            = "2.0.2"
  # blue_image_name           = "scalarlabs/scalar-ledger"
  # green_resource_count      = "0"
  # green_image_tag           = "2.0.2"
  # replication_factor        = "3"
  # green_image_name          = "scalarlabs/scalar-ledger"
  # enable_tdagent            = "true"
}

envoy = {
  # resource_type             = "Standard_B2s"
  # resource_count            = "0"
  # resource_root_volume_size = "64"
  # target_port               = "50051"
  # listen_port               = "50051"
  # enable_nlb                = "false"
  # nlb_internal              = "false"
  # enable_tdagent            = "true"
  # key                       = ""
  # cert                      = ""
  # tag                       = "v1.12.3"
  # image                     = "envoyproxy/envoy"
  # tls                       = "false"
  # cert_auto_gen             = "true"
  # custom_config_path        = ""
}
