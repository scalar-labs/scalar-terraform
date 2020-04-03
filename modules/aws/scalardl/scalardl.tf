module "scalardl_blue" {
  source = "./cluster"

  security_group_ids        = aws_security_group.scalardl.*.id
  bastion_ip                = local.bastion_ip
  network_name              = local.network_name
  resource_type             = local.scalardl.resource_type
  resource_count            = local.scalardl.blue_resource_count
  resource_cluster_name     = "blue"
  resource_root_volume_size = local.scalardl.resource_root_volume_size
  triggers                  = local.triggers
  private_key_path          = local.private_key_path
  user_name                 = local.user_name
  subnet_id                 = local.blue_subnet_id
  image_id                  = local.image_id
  key_name                  = local.key_name
  network_dns               = local.network_dns
  scalardl_image_name       = local.scalardl.blue_image_name
  scalardl_image_tag        = local.scalardl.blue_image_tag
  replication_factor        = local.scalardl.replication_factor
  enable_tdagent            = local.scalardl.enable_tdagent
  internal_domain           = local.internal_domain
  custom_tags               = var.custom_tags
}

module "scalardl_green" {
  source = "./cluster"

  security_group_ids        = aws_security_group.scalardl.*.id
  bastion_ip                = local.bastion_ip
  network_name              = local.network_name
  resource_type             = local.scalardl.resource_type
  resource_count            = local.scalardl.green_resource_count
  resource_cluster_name     = "green"
  resource_root_volume_size = local.scalardl.resource_root_volume_size
  triggers                  = local.triggers
  private_key_path          = local.private_key_path
  user_name                 = local.user_name
  subnet_id                 = local.green_subnet_id
  image_id                  = local.image_id
  key_name                  = local.key_name
  network_dns               = local.network_dns
  scalardl_image_name       = local.scalardl.green_image_name
  scalardl_image_tag        = local.scalardl.green_image_tag
  replication_factor        = local.scalardl.replication_factor
  enable_tdagent            = local.scalardl.enable_tdagent
  internal_domain           = local.internal_domain
  custom_tags               = var.custom_tags
}

resource "aws_security_group" "scalardl" {
  count = local.scalardl.green_resource_count > 0 || local.scalardl.blue_resource_count > 0 ? 1 : 0

  name        = "${local.network_name}-scalardl-nodes"
  description = "Scalar DL Security Rules"
  vpc_id      = local.network_id

  tags = merge(
    var.custom_tags,
    {
      Name      = "${local.network_name} Scalar DL"
      Terraform = "true"
      Network   = local.network_name
    }
  )
}

resource "aws_security_group_rule" "scalardl_ssh" {
  count = local.scalardl.green_resource_count > 0 || local.scalardl.blue_resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Scalar DL SSH"

  security_group_id = aws_security_group.scalardl[count.index].id
}

resource "aws_security_group_rule" "scalardl_target_port" {
  count = local.scalardl.green_resource_count > 0 || local.scalardl.blue_resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = local.scalardl.target_port
  to_port     = local.scalardl.target_port
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Scalar DL Target Port"

  security_group_id = aws_security_group.scalardl[count.index].id
}

resource "aws_security_group_rule" "scalardl_privileged_port" {
  count = local.scalardl.green_resource_count > 0 || local.scalardl.blue_resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = local.scalardl.privileged_target_port
  to_port     = local.scalardl.privileged_target_port
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Scalar DL Privileged Port"

  security_group_id = aws_security_group.scalardl[count.index].id
}

resource "aws_security_group_rule" "scalardl_admin_port" {
  count = local.scalardl.green_resource_count > 0 || local.scalardl.blue_resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = 50053
  to_port     = 50053
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Scalar DL Admin Port"

  security_group_id = aws_security_group.scalardl[count.index].id
}

resource "aws_security_group_rule" "scalardl_node_exporter" {
  count = local.scalardl.green_resource_count > 0 || local.scalardl.blue_resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = 9100
  to_port     = 9100
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Scalar DL Prometheus Node Exporter"

  security_group_id = aws_security_group.scalardl[count.index].id
}

resource "aws_security_group_rule" "scalardl_cadvisor" {
  count = local.scalardl.green_resource_count > 0 || local.scalardl.blue_resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = 18080
  to_port     = 18080
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Scalar DL cAdvisor"

  security_group_id = aws_security_group.scalardl[count.index].id
}

resource "aws_security_group_rule" "scalardl_egress" {
  count = local.scalardl.green_resource_count > 0 || local.scalardl.blue_resource_count > 0 ? 1 : 0

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "all"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Scalar DL Egress"

  security_group_id = aws_security_group.scalardl[count.index].id
}

resource "aws_route53_record" "scalardl-dns" {
  count = local.scalardl.green_resource_count > 0 || local.scalardl.blue_resource_count > 0 ? 1 : 0

  zone_id = local.network_dns
  name    = "scalardl"
  type    = "A"
  ttl     = "300"
  records = concat(
    local.scalardl.blue_discoverable_by_envoy ? module.scalardl_blue.ip : [],
    local.scalardl.green_discoverable_by_envoy ? module.scalardl_green.ip : []
  )
}

resource "aws_route53_record" "scalardl-blue-dns" {
  count = local.scalardl.blue_resource_count

  zone_id = local.network_dns
  name    = "scalardl-blue-${count.index + 1}"
  type    = "A"
  ttl     = "300"
  records = [module.scalardl_blue.ip[count.index]]
}

resource "aws_route53_record" "scalardl-green-dns" {
  count = local.scalardl.green_resource_count

  zone_id = local.network_dns
  name    = "scalardl-green-${count.index + 1}"
  type    = "A"
  ttl     = "300"
  records = [module.scalardl_green.ip[count.index]]
}

resource "aws_route53_record" "scalardl-blue-cadvisor-dns-srv" {
  count = local.scalardl.blue_resource_count > 0 ? 1 : 0

  zone_id = local.network_dns
  name    = "_cadvisor._tcp.scalardl-blue"
  type    = "SRV"
  ttl     = "300"
  records = formatlist(
    "0 0 18080 %s.%s",
    aws_route53_record.scalardl-blue-dns.*.name,
    "${local.internal_domain}.",
  )
}

resource "aws_route53_record" "scalardl-green-cadvisor-dns-srv" {
  count = local.scalardl.green_resource_count > 0 ? 1 : 0

  zone_id = local.network_dns
  name    = "_cadvisor._tcp.scalardl-green"
  type    = "SRV"
  ttl     = "300"
  records = formatlist(
    "0 0 18080 %s.%s",
    aws_route53_record.scalardl-green-dns.*.name,
    "${local.internal_domain}.",
  )
}

resource "aws_route53_record" "scalardl-blue-node-exporter-dns-srv" {
  count = local.scalardl.blue_resource_count > 0 ? 1 : 0

  zone_id = local.network_dns
  name    = "_node-exporter._tcp.scalardl-blue"
  type    = "SRV"
  ttl     = "300"
  records = formatlist(
    "0 0 9100 %s.%s",
    aws_route53_record.scalardl-blue-dns.*.name,
    "${local.internal_domain}.",
  )
}

resource "aws_route53_record" "scalardl-green-node-exporter-dns-srv" {
  count = local.scalardl.green_resource_count > 0 ? 1 : 0

  zone_id = local.network_dns
  name    = "_node-exporter._tcp.scalardl-green"
  type    = "SRV"
  ttl     = "300"
  records = formatlist(
    "0 0 9100 %s.%s",
    aws_route53_record.scalardl-green-dns.*.name,
    "${local.internal_domain}.",
  )
}

resource "aws_route53_record" "scalardl-service-dns-srv" {
  count = local.scalardl.green_resource_count > 0 || local.scalardl.blue_resource_count > 0 ? 1 : 0

  zone_id = local.network_dns
  name    = "_scalardl._tcp.scalardl-service"
  type    = "SRV"
  ttl     = "300"
  records = formatlist(
    "0 0 50053 %s.%s",
    concat(aws_route53_record.scalardl-blue-dns.*.name, aws_route53_record.scalardl-green-dns.*.name),
    "${local.internal_domain}."
  )
}
