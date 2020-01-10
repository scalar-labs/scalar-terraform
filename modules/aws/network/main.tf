module "name_generator" {
  source = "../../universal/name-generator"
  name   = var.name
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> v2.0"

  cidr = local.network.cidr
  azs  = [var.location]

  private_subnets = [
    cidrsubnet(local.network.cidr, 8, 1),
    cidrsubnet(local.network.cidr, 8, 2),
    cidrsubnet(local.network.cidr, 8, 3),
    cidrsubnet(local.network.cidr, 8, 4)
  ]
  public_subnets  = [cidrsubnet(local.network.cidr, 8, 0)]

  enable_dns_hostnames = true
  enable_dns_support   = true
  enable_nat_gateway   = true
  single_nat_gateway   = true

  igw_tags = {
    Terraform = "true"
    Name      = module.name_generator.name
  }

  tags = {
    Terraform = "true"
    Name      = module.name_generator.name
  }
}

module "dns" {
  source            = "./dns"

  network_id        = module.vpc.vpc_id
  network_name      = module.name_generator.name
  internal_root_dns = var.internal_root_dns
}

module "image" {
  source = "./ami-selector"
}

module "bastion" {
  source = "./bastion"

  network_name = module.name_generator.name
  network_id   = module.vpc.vpc_id
  network_cidr = module.vpc.vpc_cidr_block
  network_dns  = module.dns.dns_zone_id

  subnet_id = module.vpc.public_subnets[0]
  image_id  = module.image.image_id
  user_name = local.network.user_name

  trigger = module.vpc.natgw_ids[0]

  public_key_path  = var.public_key_path
  private_key_path = var.private_key_path

  resource_type             = local.network.bastion_resource_type
  resource_count            = local.network.bastion_resource_count
  resource_root_volume_size = local.network.resource_root_volume_size
  bastion_access_cidr       = local.network.bastion_access_cidr
  enable_tdagent            = local.network.bastion_enable_tdagent
  internal_root_dns         = var.internal_root_dns
}
