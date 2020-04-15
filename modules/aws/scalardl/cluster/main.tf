module "scalardl_cluster" {
  source = "github.com/scalar-labs/terraform-aws-ec2-instance?ref=7200e68"

  name           = "${var.network_name} ScalarDL ${var.scalardl_image_tag} ${var.resource_cluster_name}"
  instance_count = var.resource_count

  ami                         = var.image_id
  instance_type               = var.resource_type
  key_name                    = var.key_name
  monitoring                  = false
  vpc_security_group_ids      = var.security_group_ids
  subnet_id                   = var.subnet_id
  associate_public_ip_address = false
  hostname_prefix             = "scalardl-${var.resource_cluster_name}"
  use_num_suffix              = true

  tags = merge(
    var.custom_tags,
    {
      Terraform = "true"
      Network   = var.network_name
      Role      = "scalardl"
      Image     = var.scalardl_image_name
      Tag       = var.scalardl_image_tag
    }
  )

  volume_tags = merge(
    var.custom_tags,
    {
      Terraform = "true"
      Network   = var.network_name
    }
  )

  root_block_device = [
    {
      volume_size           = var.resource_root_volume_size
      delete_on_termination = true
      volume_type           = "gp2"
    },
  ]
}

module "scalardl_provision" {
  source           = "../../../universal/scalardl"
  triggers         = var.triggers
  bastion_host_ip  = var.bastion_ip
  host_list        = module.scalardl_cluster.private_ip
  user_name        = var.user_name
  private_key_path = var.private_key_path
  provision_count  = var.resource_count
  enable_tdagent   = var.enable_tdagent

  scalardl_image_name = var.scalardl_image_name
  scalardl_image_tag  = var.scalardl_image_tag
  replication_factor  = var.replication_factor
  internal_domain     = var.internal_domain
  cassandra_username  = var.cassandra_username
  cassandra_password  = var.cassandra_password
}
