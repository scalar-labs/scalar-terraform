name = "terratest-azure"

location = "japaneast"

public_key_path = "../../test_key.pub"

private_key_path = "../../tests_key"

internal_root_dns = "internal.scalar-labs.com"

network = {
  # bastion_resource_type     = "Standard_D2s_v3"
  # bastion_resource_count    = 1
  # bastion_access_cidr       = "0.0.0.0/0"
  # resource_root_volume_size = 16
  # bastion_enable_tdagent    = true
  # user_name                 = "centos"
  # cidr                      = "10.42.0.0/16"
}
