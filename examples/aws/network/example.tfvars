region = "ap-northeast-1"

name = "example-aws" # maximum of 13 characters

locations = [
  "ap-northeast-1a",
  "ap-northeast-1c",
  "ap-northeast-1d",
]

public_key_path = "./example_key.pub"

private_key_path = "./example_key"

internal_domain = "internal.scalar-labs.com"

network = {
  # bastion_resource_type     = "t3.micro"
  # bastion_resource_count    = "2"
  # bastion_access_cidr       = "0.0.0.0/0"
  # resource_root_volume_size = "16"
  # bastion_enable_tdagent    = "true"
  # user_name                 = "centos"
  # cidr                      = "10.42.0.0/16"
}
