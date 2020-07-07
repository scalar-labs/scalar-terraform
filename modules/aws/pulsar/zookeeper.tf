module "zookeeper_cluster" {
  source = "github.com/scalar-labs/terraform-aws-ec2-instance?ref=7200e68"

  name           = "${local.network_name} Zookeeper Cluster"
  instance_count = local.zookeeper.resource_count

  ami                         = local.image_id
  instance_type               = local.zookeeper.resource_type
  key_name                    = local.key_name
  monitoring                  = false
  vpc_security_group_ids      = aws_security_group.zookeeper.*.id
  subnet_ids                  = local.subnet_ids
  associate_public_ip_address = false
  hostname_prefix             = "zookeeper"
  use_num_suffix              = true

  tags = merge(
    var.custom_tags,
    {
      Terraform = "true"
      Network   = local.network_name
      Role      = "zookeeper"
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
      volume_size           = local.zookeeper.resource_root_volume_size
      delete_on_termination = true
      volume_type           = "gp2"
    },
  ]
}

resource "aws_security_group" "zookeeper" {
  count = local.zookeeper.resource_count > 0 ? 1 : 0

  name        = "${local.network_name}-zookeeper"
  description = "Zookeeper nodes"
  vpc_id      = local.network_id

  tags = merge(
    var.custom_tags,
    {
      Name      = "${local.network_name} Zookeeper"
      Terraform = "true"
      Network   = local.network_name
    }
  )
}

resource "aws_security_group_rule" "zookeeper_ssh" {
  count = local.zookeeper.resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Zookeeper SSH"

  security_group_id = aws_security_group.zookeeper[count.index].id
}

resource "aws_security_group_rule" "zookeeper_service" {
  count = local.zookeeper.resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = 2181
  to_port     = 2181
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Zookeeper client port"

  security_group_id = aws_security_group.zookeeper[count.index].id
}

resource "aws_security_group_rule" "zookeeper_peerport" {
  count = local.zookeeper.resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = 2888
  to_port     = 2888
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Zookeeper peer port"

  security_group_id = aws_security_group.zookeeper[count.index].id
}

resource "aws_security_group_rule" "zookeeper_leaderport" {
  count = local.zookeeper.resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = 3888
  to_port     = 3888
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Zookeeper ledger port"

  security_group_id = aws_security_group.zookeeper[count.index].id
}

resource "aws_security_group_rule" "zookeeper_admin" {
  count = local.zookeeper.resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = 8080
  to_port     = 8080
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Zookeeper admin port"

  security_group_id = aws_security_group.zookeeper[count.index].id
}

resource "aws_security_group_rule" "zookeeper_egress" {
  count = local.zookeeper.resource_count > 0 ? 1 : 0

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "all"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.zookeeper[count.index].id
}

resource "aws_route53_record" "zookeeper_dns" {
  count = local.zookeeper.resource_count

  zone_id = local.network_dns
  name    = "zookeeper-${count.index + 1}"
  type    = "A"
  ttl     = "300"
  records = [module.zookeeper_cluster.private_ip[count.index]]
}

resource "aws_route53_record" "zookeeper_exporter_dns_srv" {
  count = local.zookeeper.resource_count > 0 ? 1 : 0

  zone_id = local.network_dns
  name    = "_zookeeper-exporter._tcp.zookeeper"
  type    = "SRV"
  ttl     = "300"
  records = formatlist(
    "0 0 7070 %s.%s",
    aws_route53_record.zookeeper_dns.*.name,
    "${local.internal_domain}.",
  )
}

resource "aws_route53_record" "zookeeper_node_exporter_dns_srv" {
  count = local.zookeeper.resource_count > 0 ? 1 : 0

  zone_id = local.network_dns
  name    = "_node-exporter._tcp.zookeeper"
  type    = "SRV"
  ttl     = "300"
  records = formatlist(
    "0 0 9100 %s.%s",
    aws_route53_record.zookeeper_dns.*.name,
    "${local.internal_domain}.",
  )
}
