region = "ap-northeast-1"

name = "example-aws"

location = "ap-northeast-1a"

public_key_path = "./your_pub.pem"

private_key_path = "./your_private.pem"

internal_root_dns = "internal.scalar-labs.com"

network = {
  bastion_resource_type = "t3.micro"
  cidr                  = "10.42.0.0/16"
}
