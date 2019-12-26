module "reaper_cluster" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> v2.0"

  name           = "${local.network_name} Reaper Cluster"
  instance_count = local.reaper.resource_count

  ami                         = local.image_id
  instance_type               = local.reaper.resource_type
  key_name                    = local.key_name
  monitoring                  = false
  vpc_security_group_ids      = aws_security_group.reaper.*.id
  subnet_id                   = local.subnet_id
  associate_public_ip_address = false

  tags = {
    Terraform = true
    Network   = local.network_name
    Role      = "reaper"
  }

  root_block_device = [
    {
      volume_size           = local.reaper.resource_root_volume_size
      delete_on_termination = true
      volume_type           = "gp2"
    },
  ]
}

module "reaper_provision" {
  source             = "../../universal/reaper"
  triggers           = local.triggers
  bastion_host_ip    = local.bastion_ip
  host_list          = module.reaper_cluster.private_ip
  user_name          = local.user_name
  private_key_path   = local.private_key_path
  provision_count    = local.reaper.resource_count
  replication_factor = local.reaper.repliation_factor
  enable_tdagent     = local.reaper.enable_tdagent
  internal_root_dns  = local.internal_root_dns
}

resource "aws_security_group" "reaper" {
  count = local.reaper_create_count

  name        = "${local.network_name}-reaper-nodes"
  description = "Reaper nodes"
  vpc_id      = local.network_id

  tags = {
    Name = "${local.network_name} reaper"
  }
}

resource "aws_security_group_rule" "reaper_ssh" {
  count = local.reaper_create_count

  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Reaper SSH"

  security_group_id = aws_security_group.reaper[count.index].id
}

resource "aws_security_group_rule" "reaper_ui" {
  count = local.reaper_create_count

  type        = "ingress"
  from_port   = 8080
  to_port     = 8081
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Reaper UI"

  security_group_id = aws_security_group.reaper[count.index].id
}

resource "aws_security_group_rule" "reaper_node_expoter" {
  count = local.reaper_create_count

  type        = "ingress"
  from_port   = 9100
  to_port     = 9100
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Reaper Prometheus Node Exporter"

  security_group_id = aws_security_group.reaper[count.index].id
}

resource "aws_security_group_rule" "reaper_cadvisor" {
  count = local.reaper_create_count

  type        = "ingress"
  from_port   = 18080
  to_port     = 18080
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Reaper cAdvisor"

  security_group_id = aws_security_group.reaper[count.index].id
}

resource "aws_security_group_rule" "reaper_egress" {
  count = local.reaper_create_count

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "all"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Reaper Egress"

  security_group_id = aws_security_group.reaper[count.index].id
}

resource "aws_route53_record" "reaper-dns" {
  count = local.reaper_create_count

  zone_id = local.network_dns
  name    = "reaper"
  type    = "A"
  ttl     = "300"
  records = module.reaper_cluster.private_ip
}

resource "aws_route53_record" "reaper-dns-srv" {
  count = local.reaper_create_count

  zone_id = local.network_dns
  name    = "_reaper._tcp.reaper"
  type    = "SRV"
  ttl     = "300"
  records = formatlist(
    "0 0 8081 %s.%s",
    aws_route53_record.reaper-dns.*.name,
    "${local.internal_root_dns}.",
  )
}

resource "aws_route53_record" "reaper-cadvisor-dns-srv" {
  count = local.reaper_create_count

  zone_id = local.network_dns
  name    = "_cadvisor._tcp.reaper"
  type    = "SRV"
  ttl     = "300"
  records = formatlist(
    "0 0 18080 %s.%s",
    aws_route53_record.reaper-dns.*.name,
    "${local.internal_root_dns}.",
  )
}

resource "aws_route53_record" "reaper-node-exporter-dns-srv" {
  count = local.reaper_create_count

  zone_id = local.network_dns
  name    = "_node-exporter._tcp.reaper"
  type    = "SRV"
  ttl     = "300"
  records = formatlist(
    "0 0 9100 %s.%s",
    aws_route53_record.reaper-dns.*.name,
    "${local.internal_root_dns}.",
  )
}
