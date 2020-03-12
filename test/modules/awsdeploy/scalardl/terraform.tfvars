region = "us-east-1"

envoy = {
  resource_count     = 3
  enable_nlb         = true
  custom_config_path = "../../envoy_config"
}
