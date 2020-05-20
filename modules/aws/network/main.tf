module "name_generator" {
  source = "../../universal/name-generator"
  name   = var.name
}

module "vpc" {
  source = "github.com/scalar-labs/terraform-aws-vpc?ref=32c0802"

  cidr = local.network.cidr
  azs  = local.locations

  private_subnets = concat(
    local.subnet_map.private,
    local.subnet_map.cassandra,
    local.subnet_map.scalardl_blue,
    local.subnet_map.scalardl_green
  )
  public_subnets = local.subnet_map.public

  enable_dns_hostnames   = true
  enable_dns_support     = true
  enable_nat_gateway     = true
  single_nat_gateway     = false
  one_nat_gateway_per_az = true

  igw_tags = merge(
    var.custom_tags,
    {
      Name      = module.name_generator.name
      Network   = module.name_generator.name
      Terraform = "true"
    }
  )

  tags = merge(
    var.custom_tags,
    {
      Name      = module.name_generator.name
      Network   = module.name_generator.name
      Terraform = "true"
    }
  )
}

module "dns" {
  source = "./dns"

  network_id      = module.vpc.vpc_id
  network_name    = module.name_generator.name
  internal_domain = var.internal_domain
  custom_tags     = var.custom_tags
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

  subnet_ids = module.vpc.public_subnets
  image_id   = module.image.image_id
  user_name  = local.network.user_name

  trigger = module.vpc.natgw_ids[0]

  public_key_path             = var.public_key_path
  private_key_path            = var.private_key_path
  additional_public_keys_path = var.additional_public_keys_path

  resource_type             = local.network.bastion_resource_type
  resource_count            = local.network.bastion_resource_count
  resource_root_volume_size = local.network.resource_root_volume_size
  bastion_access_cidr       = local.network.bastion_access_cidr
  enable_tdagent            = local.network.bastion_enable_tdagent
  internal_domain           = var.internal_domain
  custom_tags               = var.custom_tags
}
