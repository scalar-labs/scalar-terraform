locals {
  network = {
    cidr     = "10.42.0.0/16"
    name     = "example-aws"
    dns      = "Z08111302BU37G0O8OMMY"
    id       = "vpc-08f36c547a1aca222"
    location = "ap-northeast-1"

    subnet_id = "subnet-0fcdd0a1f75e86b1e"
    image_id  = "ami-0d9d854feeddeef21"
    key_name  = "example-aws-xxxxxxx-key"

    bastion_ip           = "13.231.179.116"
    bastion_provision_id = "9139872180792820156"

    private_key_path  = "../network/example_key"
    user_name         = "centos"
    internal_root_dns = "internal.scalar-labs.com"
  }
}
