module "reaper_cluster" {
  source = "github.com/scalar-labs/terraform-aws-ec2-instance?ref=6a2b26c"

  name           = "${local.network_name} Reaper Cluster"
  instance_count = local.reaper.resource_count

  ami                         = local.image_id
  instance_type               = local.reaper.resource_type
  key_name                    = local.key_name
  monitoring                  = false
  vpc_security_group_ids      = aws_security_group.reaper.*.id
  subnet_ids                  = local.subnet_ids
  associate_public_ip_address = false
  hostname_prefix             = "reaper"
  use_num_suffix              = true

  tags = merge(
    var.custom_tags,
    {
      Terraform = "true"
      Network   = local.network_name
      Role      = "reaper"
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
      volume_size           = local.reaper.resource_root_volume_size
      delete_on_termination = true
      volume_type           = "gp2"
    },
  ]
}

module "reaper_provision" {
  source             = "../../universal/reaper"
  vm_ids             = module.reaper_cluster.id
  triggers           = local.triggers
  bastion_host_ip    = local.bastion_ip
  host_list          = module.reaper_cluster.private_ip
  user_name          = local.user_name
  private_key_path   = local.private_key_path
  provision_count    = local.reaper.resource_count
  replication_factor = local.reaper.replication_factor
  enable_tdagent     = local.reaper.enable_tdagent
  internal_domain    = local.internal_domain
  cassandra_username = local.reaper.cassandra_username
  cassandra_password = local.reaper.cassandra_password
}

resource "aws_security_group" "reaper" {
  count = local.reaper.resource_count > 0 ? 1 : 0

  name        = "${local.network_name}-reaper-nodes"
  description = "Reaper nodes"
  vpc_id      = local.network_id

  tags = merge(
    var.custom_tags,
    {
      Name      = "${local.network_name} reaper"
      Terraform = "true"
      Network   = local.network_name
    }
  )
}

resource "aws_security_group_rule" "reaper_ssh" {
  count = local.reaper.resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Reaper SSH"

  security_group_id = aws_security_group.reaper[count.index].id
}

resource "aws_security_group_rule" "reaper_ui" {
  count = local.reaper.resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = 8080
  to_port     = 8081
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Reaper UI"

  security_group_id = aws_security_group.reaper[count.index].id
}

resource "aws_security_group_rule" "reaper_node_expoter" {
  count = local.reaper.resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = 9100
  to_port     = 9100
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Reaper Prometheus Node Exporter"

  security_group_id = aws_security_group.reaper[count.index].id
}

resource "aws_security_group_rule" "reaper_cadvisor" {
  count = local.reaper.resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = 18080
  to_port     = 18080
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Reaper cAdvisor"

  security_group_id = aws_security_group.reaper[count.index].id
}

resource "aws_security_group_rule" "reaper_fluentd_prometheus" {
  count = local.reaper.resource_count > 0 && local.reaper.enable_tdagent ? 1 : 0

  type        = "ingress"
  from_port   = 24231
  to_port     = 24231
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Reaper fluentd-plugin-prometheus"

  security_group_id = aws_security_group.reaper[count.index].id
}

resource "aws_security_group_rule" "reaper_egress" {
  count = local.reaper.resource_count > 0 ? 1 : 0

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "all"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Reaper Egress"

  security_group_id = aws_security_group.reaper[count.index].id
}

resource "aws_route53_record" "reaper_dns" {
  count = local.reaper.resource_count

  zone_id = local.network_dns
  name    = "reaper-${count.index + 1}"
  type    = "A"
  ttl     = "300"
  records = [module.reaper_cluster.private_ip[count.index]]
}

resource "aws_route53_record" "reaper_dns_srv" {
  count = local.reaper.resource_count > 0 ? 1 : 0

  zone_id = local.network_dns
  name    = "_reaper._tcp.reaper"
  type    = "SRV"
  ttl     = "300"
  records = formatlist(
    "0 0 8081 %s.%s",
    aws_route53_record.reaper_dns.*.name,
    "${local.internal_domain}.",
  )
}

resource "aws_route53_record" "reaper_cadvisor_dns_srv" {
  count = local.reaper.resource_count > 0 ? 1 : 0

  zone_id = local.network_dns
  name    = "_cadvisor._tcp.reaper"
  type    = "SRV"
  ttl     = "300"
  records = formatlist(
    "0 0 18080 %s.%s",
    aws_route53_record.reaper_dns.*.name,
    "${local.internal_domain}.",
  )
}

resource "aws_route53_record" "reaper_node_exporter_dns_srv" {
  count = local.reaper.resource_count > 0 ? 1 : 0

  zone_id = local.network_dns
  name    = "_node-exporter._tcp.reaper"
  type    = "SRV"
  ttl     = "300"
  records = formatlist(
    "0 0 9100 %s.%s",
    aws_route53_record.reaper_dns.*.name,
    "${local.internal_domain}.",
  )
}

resource "aws_route53_record" "reaper_fluentd_prometheus_dns_srv" {
  count = local.reaper.resource_count > 0 && local.reaper.enable_tdagent ? 1 : 0

  zone_id = local.network_dns
  name    = "_fluentd._tcp.reaper"
  type    = "SRV"
  ttl     = "300"
  records = formatlist(
    "0 0 24231 %s.%s",
    aws_route53_record.reaper_dns.*.name,
    "${local.internal_domain}.",
  )
}
