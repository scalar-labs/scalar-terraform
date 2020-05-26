module "ca_cluster" {
  source = "github.com/scalar-labs/terraform-aws-ec2-instance?ref=7200e68"

  name           = "${local.network_name} ca Cluster"
  instance_count = local.ca.resource_count

  ami                         = local.image_id
  instance_type               = local.ca.resource_type
  key_name                    = local.key_name
  monitoring                  = false
  vpc_security_group_ids      = aws_security_group.ca.*.id
  subnet_ids                  = local.subnet_ids
  associate_public_ip_address = false
  hostname_prefix             = "ca"
  use_num_suffix              = true

  tags = merge(
    var.custom_tags,
    {
      Terraform = "true"
      Network   = local.network_name
      Role      = "ca"
    }
  )

  volume_tags = merge(
    var.custom_tags,
    {
      Terraform = "true"
      Network   = local.network_name
    }
  )

  root_block_device = [
    {
      volume_size           = local.ca.resource_root_volume_size
      delete_on_termination = true
      volume_type           = "gp2"
    },
  ]
}

module "ca_provision" {
  source           = "../../universal/ca"
  vm_ids           = module.ca_cluster.id
  triggers         = local.triggers
  bastion_host_ip  = local.bastion_ip
  host_list        = module.ca_cluster.private_ip
  user_name        = local.user_name
  private_key_path = local.private_key_path
  provision_count  = local.ca.resource_count
  enable_tdagent   = local.ca.enable_tdagent
  internal_domain  = local.internal_domain
}

resource "aws_security_group" "ca" {
  count = local.ca.resource_count > 0 ? 1 : 0

  name        = "${local.network_name}-ca-nodes"
  description = "ca nodes"
  vpc_id      = local.network_id

  tags = merge(
    var.custom_tags,
    {
      Name      = "${local.network_name} ca"
      Terraform = "true"
      Network   = local.network_name
    }
  )
}

resource "aws_security_group_rule" "ca_ssh" {
  count = local.ca.resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "CA SSH"

  security_group_id = aws_security_group.ca[count.index].id
}

resource "aws_security_group_rule" "ca_cfssl" {
  count = local.ca.resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = 8888
  to_port     = 8889
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "CA cfssl"

  security_group_id = aws_security_group.ca[count.index].id
}

resource "aws_security_group_rule" "ca_node_exporter" {
  count = local.ca.resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = 9100
  to_port     = 9100
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "CA Prometheus Node Exporter"

  security_group_id = aws_security_group.ca[count.index].id
}

resource "aws_security_group_rule" "ca_cadvisor" {
  count = local.ca.resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = 18080
  to_port     = 18080
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "CA cAdvisor"

  security_group_id = aws_security_group.ca[count.index].id
}

resource "aws_security_group_rule" "ca_egress" {
  count = local.ca.resource_count > 0 ? 1 : 0

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "all"
  cidr_blocks = ["0.0.0.0/0"]
  description = "CA Egress"

  security_group_id = aws_security_group.ca[count.index].id
}

resource "aws_route53_record" "ca_dns" {
  count = local.ca.resource_count

  zone_id = local.network_dns
  name    = "ca-${count.index + 1}"
  type    = "A"
  ttl     = "300"
  records = [module.ca_cluster.private_ip[count.index]]
}
