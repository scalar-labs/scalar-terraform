module "broker_cluster" {
  source = "github.com/scalar-labs/terraform-aws-ec2-instance?ref=7200e68"

  name           = "${local.network_name} Broker Cluster"
  instance_count = local.broker.resource_count

  ami                         = local.image_id
  instance_type               = local.broker.resource_type
  key_name                    = local.key_name
  monitoring                  = false
  vpc_security_group_ids      = aws_security_group.broker.*.id
  subnet_ids                  = local.subnet_ids
  associate_public_ip_address = false
  hostname_prefix             = "broker"
  use_num_suffix              = true

  tags = merge(
    var.custom_tags,
    {
      Terraform = "true"
      Network   = local.network_name
      Role      = "broker"
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
      volume_size           = local.broker.resource_root_volume_size
      delete_on_termination = true
      volume_type           = "gp2"
    },
  ]
}

resource "aws_security_group" "broker" {
  count = local.broker.resource_count > 0 ? 1 : 0

  name        = "${local.network_name}-broker"
  description = "Broker nodes"
  vpc_id      = local.network_id

  tags = merge(
    var.custom_tags,
    {
      Name      = "${local.network_name} Broker"
      Terraform = "true"
      Network   = local.network_name
    }
  )
}

resource "aws_security_group_rule" "broker_ssh" {
  count = local.broker.resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Broker SSH"

  security_group_id = aws_security_group.broker[count.index].id
}

resource "aws_security_group_rule" "broker_service" {
  count = local.broker.resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = 6650
  to_port     = 6651
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Broker 6650 - 6651"

  security_group_id = aws_security_group.broker[count.index].id
}

resource "aws_security_group_rule" "broker_egress" {
  count = local.broker.resource_count > 0 ? 1 : 0

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "all"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.broker[count.index].id
}

resource "aws_route53_record" "broker_dns" {
  count = local.broker.resource_count

  zone_id = local.network_dns
  name    = "broker-${count.index + 1}"
  type    = "A"
  ttl     = "300"
  records = [module.broker_cluster.private_ip[count.index]]
}

resource "aws_route53_record" "broker_dns_lb" {
  count = local.broker.resource_count > 0 ? 1 : 0

  zone_id = local.network_dns
  name    = "broker-lb"
  type    = "A"
  ttl     = "300"
  records = module.broker_cluster.private_ip
}

resource "aws_route53_record" "broker_exporter_dns_srv" {
  count = local.broker.resource_count > 0 ? 1 : 0

  zone_id = local.network_dns
  name    = "_broker-exporter._tcp.broker"
  type    = "SRV"
  ttl     = "300"
  records = formatlist(
    "0 0 7070 %s.%s",
    aws_route53_record.broker_dns.*.name,
    "${local.internal_domain}.",
  )
}

resource "aws_route53_record" "broker_node_exporter_dns_srv" {
  count = local.broker.resource_count > 0 ? 1 : 0

  zone_id = local.network_dns
  name    = "_node-exporter._tcp.broker"
  type    = "SRV"
  ttl     = "300"
  records = formatlist(
    "0 0 9100 %s.%s",
    aws_route53_record.broker_dns.*.name,
    "${local.internal_domain}.",
  )
}
