module "scalardl_blue" {
  source = "./cluster"

  security_group_ids           = aws_security_group.scalardl.*.id
  bastion_ip                   = local.bastion_ip
  network_name                 = local.network_name
  resource_type                = local.scalardl.resource_type
  resource_count               = local.scalardl.blue_resource_count
  resource_cluster_name        = "blue"
  resource_root_volume_size    = local.scalardl.resource_root_volume_size
  private_key_path             = local.private_key_path
  user_name                    = local.user_name
  subnet_ids                   = local.blue_subnet_ids
  image_id                     = local.image_id
  key_name                     = local.key_name
  network_dns                  = local.network_dns
  scalardl_image_name          = local.scalardl.blue_image_name
  scalardl_image_tag           = local.scalardl.blue_image_tag
  container_env_file           = local.scalardl.container_env_file
  enable_tdagent               = local.scalardl.enable_tdagent
  internal_domain              = local.internal_domain
  cassandra_replication_factor = local.scalardl.cassandra_replication_factor
  custom_tags                  = var.custom_tags
}

module "scalardl_green" {
  source = "./cluster"

  security_group_ids           = aws_security_group.scalardl.*.id
  bastion_ip                   = local.bastion_ip
  network_name                 = local.network_name
  resource_type                = local.scalardl.resource_type
  resource_count               = local.scalardl.green_resource_count
  resource_cluster_name        = "green"
  resource_root_volume_size    = local.scalardl.resource_root_volume_size
  private_key_path             = local.private_key_path
  user_name                    = local.user_name
  subnet_ids                   = local.green_subnet_ids
  image_id                     = local.image_id
  key_name                     = local.key_name
  network_dns                  = local.network_dns
  scalardl_image_name          = local.scalardl.green_image_name
  scalardl_image_tag           = local.scalardl.green_image_tag
  container_env_file           = local.scalardl.container_env_file
  enable_tdagent               = local.scalardl.enable_tdagent
  internal_domain              = local.internal_domain
  cassandra_replication_factor = local.scalardl.cassandra_replication_factor
  custom_tags                  = var.custom_tags
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

resource "aws_security_group_rule" "scalardl_port" {
  count = local.scalardl.green_resource_count > 0 || local.scalardl.blue_resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = 50051
  to_port     = 50051
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Scalar DL Port"

  security_group_id = aws_security_group.scalardl[count.index].id
}

resource "aws_security_group_rule" "scalardl_privileged_port" {
  count = local.scalardl.green_resource_count > 0 || local.scalardl.blue_resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = 50052
  to_port     = 50052
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

resource "aws_security_group_rule" "scalardl_fluentd_prometheus" {
  count = (local.scalardl.green_resource_count > 0 || local.scalardl.blue_resource_count > 0) && local.scalardl.enable_tdagent ? 1 : 0

  type        = "ingress"
  from_port   = 24231
  to_port     = 24231
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Scalar DL fluentd-plugin-prometheus"

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

resource "aws_route53_record" "scalardl_dns" {
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

resource "aws_route53_record" "scalardl_blue_dns" {
  count = local.scalardl.blue_resource_count

  zone_id = local.network_dns
  name    = "scalardl-blue-${count.index + 1}"
  type    = "A"
  ttl     = "300"
  records = [module.scalardl_blue.ip[count.index]]
}

resource "aws_route53_record" "scalardl_green_dns" {
  count = local.scalardl.green_resource_count

  zone_id = local.network_dns
  name    = "scalardl-green-${count.index + 1}"
  type    = "A"
  ttl     = "300"
  records = [module.scalardl_green.ip[count.index]]
}

resource "aws_route53_record" "scalardl_blue_cadvisor_dns_srv" {
  count = local.scalardl.blue_resource_count > 0 ? 1 : 0

  zone_id = local.network_dns
  name    = "_cadvisor._tcp.scalardl-blue"
  type    = "SRV"
  ttl     = "300"
  records = formatlist(
    "0 0 18080 %s.%s",
    aws_route53_record.scalardl_blue_dns.*.name,
    "${local.internal_domain}.",
  )
}

resource "aws_route53_record" "scalardl_green_cadvisor_dns_srv" {
  count = local.scalardl.green_resource_count > 0 ? 1 : 0

  zone_id = local.network_dns
  name    = "_cadvisor._tcp.scalardl-green"
  type    = "SRV"
  ttl     = "300"
  records = formatlist(
    "0 0 18080 %s.%s",
    aws_route53_record.scalardl_green_dns.*.name,
    "${local.internal_domain}.",
  )
}

resource "aws_route53_record" "scalardl_blue_node_exporter_dns_srv" {
  count = local.scalardl.blue_resource_count > 0 ? 1 : 0

  zone_id = local.network_dns
  name    = "_node-exporter._tcp.scalardl-blue"
  type    = "SRV"
  ttl     = "300"
  records = formatlist(
    "0 0 9100 %s.%s",
    aws_route53_record.scalardl_blue_dns.*.name,
    "${local.internal_domain}.",
  )
}

resource "aws_route53_record" "scalardl_green_node_exporter_dns_srv" {
  count = local.scalardl.green_resource_count > 0 ? 1 : 0

  zone_id = local.network_dns
  name    = "_node-exporter._tcp.scalardl-green"
  type    = "SRV"
  ttl     = "300"
  records = formatlist(
    "0 0 9100 %s.%s",
    aws_route53_record.scalardl_green_dns.*.name,
    "${local.internal_domain}.",
  )
}

resource "aws_route53_record" "scalardl_blue_fluentd_prometheus_dns_srv" {
  count = local.scalardl.blue_resource_count > 0 && local.scalardl.enable_tdagent ? 1 : 0

  zone_id = local.network_dns
  name    = "_fluentd._tcp.scalardl-blue"
  type    = "SRV"
  ttl     = "300"
  records = formatlist(
    "0 0 24231 %s.%s",
    aws_route53_record.scalardl_blue_dns.*.name,
    "${local.internal_domain}.",
  )
}

resource "aws_route53_record" "scalardl_green_fluentd_prometheus_dns_srv" {
  count = local.scalardl.green_resource_count > 0 && local.scalardl.enable_tdagent ? 1 : 0

  zone_id = local.network_dns
  name    = "_fluentd._tcp.scalardl-green"
  type    = "SRV"
  ttl     = "300"
  records = formatlist(
    "0 0 24231 %s.%s",
    aws_route53_record.scalardl_green_dns.*.name,
    "${local.internal_domain}.",
  )
}

resource "aws_route53_record" "scalardl_service_dns_srv" {
  count = local.scalardl.green_resource_count > 0 || local.scalardl.blue_resource_count > 0 ? 1 : 0

  zone_id = local.network_dns
  name    = "_scalardl._tcp.scalardl-service"
  type    = "SRV"
  ttl     = "300"
  records = formatlist(
    "0 0 50053 %s.%s",
    concat(aws_route53_record.scalardl_blue_dns.*.name, aws_route53_record.scalardl_green_dns.*.name),
    "${local.internal_domain}."
  )
}
