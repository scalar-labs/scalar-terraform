module "cassy_cluster" {
  source = "github.com/scalar-labs/terraform-aws-ec2-instance?ref=6a2b26c"

  name           = "${local.network_name} Cassy Cluster"
  instance_count = local.cassy.resource_count

  ami                         = local.image_id
  instance_type               = local.cassy.resource_type
  key_name                    = local.key_name
  monitoring                  = false
  vpc_security_group_ids      = aws_security_group.cassy.*.id
  subnet_ids                  = local.subnet_ids
  associate_public_ip_address = false
  hostname_prefix             = "cassy"
  iam_instance_profile        = aws_iam_instance_profile.cassandra.name
  use_num_suffix              = true

  tags = merge(
    var.custom_tags,
    {
      Terraform = "true"
      Network   = local.network_name
      Role      = "cassy"
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
      volume_size           = local.cassy.resource_root_volume_size
      delete_on_termination = true
      volume_type           = "gp2"
    },
  ]
}

module "cassy_provision" {
  source = "../../universal/cassy"

  vm_ids           = module.cassy_cluster.id
  triggers         = local.triggers
  bastion_host_ip  = local.bastion_ip
  host_list        = module.cassy_cluster.private_ip
  user_name        = local.user_name
  private_key_path = local.private_key_path
  provision_count  = local.cassy.resource_count
  enable_tdagent   = local.cassy.enable_tdagent
  internal_domain  = local.internal_domain
  image_tag        = local.cassy.image_tag
  storage_base_uri = local.cassy.storage_base_uri
  storage_type     = local.cassy.storage_type
}

resource "aws_security_group" "cassy" {
  count = local.cassy.resource_count > 0 ? 1 : 0

  name        = "${local.network_name}-cassy-nodes"
  description = "cassy nodes"
  vpc_id      = local.network_id

  tags = merge(
    var.custom_tags,
    {
      Name      = "${local.network_name} cassy"
      Terraform = "true"
      Network   = local.network_name
    }
  )
}

resource "aws_security_group_rule" "cassy_ssh" {
  count = local.cassy.resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Cassy SSH"

  security_group_id = aws_security_group.cassy[count.index].id
}

resource "aws_security_group_rule" "cassy_grpc" {
  count = local.cassy.resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = 20051
  to_port     = 20051
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Cassy GRPC"

  security_group_id = aws_security_group.cassy[count.index].id
}

resource "aws_security_group_rule" "cassy_node_expoter" {
  count = local.cassy.resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = 9100
  to_port     = 9100
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Cassy Prometheus Node Exporter"

  security_group_id = aws_security_group.cassy[count.index].id
}

resource "aws_security_group_rule" "cassy_cadvisor" {
  count = local.cassy.resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = 18080
  to_port     = 18080
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Cassy cAdvisor"

  security_group_id = aws_security_group.cassy[count.index].id
}

resource "aws_security_group_rule" "cassy_fluentd_prometheus" {
  count = local.cassy.resource_count > 0 && local.cassy.enable_tdagent ? 1 : 0

  type        = "ingress"
  from_port   = 24231
  to_port     = 24231
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Cassy fluentd-plugin-prometheus"

  security_group_id = aws_security_group.cassy[count.index].id
}

resource "aws_security_group_rule" "cassy_egress" {
  count = local.cassy.resource_count > 0 ? 1 : 0

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "all"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Cassy Egress"

  security_group_id = aws_security_group.cassy[count.index].id
}

resource "aws_route53_record" "cassy_dns" {
  count = local.cassy.resource_count

  zone_id = local.network_dns
  name    = "cassy-${count.index + 1}"
  type    = "A"
  ttl     = "300"
  records = [module.cassy_cluster.private_ip[count.index]]
}

resource "aws_route53_record" "cassy_dns_srv" {
  count = local.cassy.resource_count > 0 ? 1 : 0

  zone_id = local.network_dns
  name    = "_cassy._tcp.cassy"
  type    = "SRV"
  ttl     = "300"
  records = formatlist(
    "0 0 8081 %s.%s",
    aws_route53_record.cassy_dns.*.name,
    "${local.internal_domain}.",
  )
}

resource "aws_route53_record" "cassy_cadvisor_dns_srv" {
  count = local.cassy.resource_count > 0 ? 1 : 0

  zone_id = local.network_dns
  name    = "_cadvisor._tcp.cassy"
  type    = "SRV"
  ttl     = "300"
  records = formatlist(
    "0 0 18080 %s.%s",
    aws_route53_record.cassy_dns.*.name,
    "${local.internal_domain}.",
  )
}

resource "aws_route53_record" "cassy_node_exporter_dns_srv" {
  count = local.cassy.resource_count > 0 ? 1 : 0

  zone_id = local.network_dns
  name    = "_node-exporter._tcp.cassy"
  type    = "SRV"
  ttl     = "300"
  records = formatlist(
    "0 0 9100 %s.%s",
    aws_route53_record.cassy_dns.*.name,
    "${local.internal_domain}.",
  )
}

resource "aws_route53_record" "cassy_fluentd_prometheus_dns_srv" {
  count = local.cassy.resource_count > 0 && local.cassy.enable_tdagent ? 1 : 0

  zone_id = local.network_dns
  name    = "_fluentd._tcp.cassy"
  type    = "SRV"
  ttl     = "300"
  records = formatlist(
    "0 0 24231 %s.%s",
    aws_route53_record.cassy_dns.*.name,
    "${local.internal_domain}.",
  )
}
