region = "ap-northeast-1"

name = "example-aws"

location = "ap-northeast-1a"

public_key_path = "./example_key.pub"

private_key_path = "./example_key"

internal_root_dns = "internal.scalar-labs.com"

network = {
  #bastion_resource_type     = "t3.micro"
  #bastion_resource_count    = 1
  #bastion_access_cidr       = "0.0.0.0/0"
  #resource_root_volume_size = 16
  #bastion_enable_tdagent    = true
  #user_name                 = "centos"
  #cidr                      = "10.42.0.0/16"
}
