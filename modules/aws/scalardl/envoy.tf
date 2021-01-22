module "envoy_cluster" {
  source = "github.com/scalar-labs/terraform-aws-ec2-instance?ref=6a2b26c"

  name           = "${local.network_name} Envoy Cluster"
  instance_count = local.envoy.resource_count

  ami                         = local.image_id
  instance_type               = local.envoy.resource_type
  key_name                    = local.key_name
  monitoring                  = false
  vpc_security_group_ids      = aws_security_group.envoy.*.id
  subnet_ids                  = local.envoy.subnet_ids
  associate_public_ip_address = false
  hostname_prefix             = "envoy"
  use_num_suffix              = true

  tags = merge(
    var.custom_tags,
    {
      Terraform = "true"
      Network   = local.network_name
      Role      = "envoy"
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
      volume_size           = local.envoy.resource_root_volume_size
      delete_on_termination = true
      volume_type           = "gp2"
    },
  ]
}

module "envoy_provision" {
  source                = "../../universal/envoy"
  vm_ids                = module.envoy_cluster.id
  triggers              = local.triggers
  bastion_host_ip       = local.bastion_ip
  host_list             = module.envoy_cluster.private_ip
  user_name             = local.user_name
  private_key_path      = local.private_key_path
  provision_count       = local.envoy.resource_count
  key                   = local.envoy.key
  cert                  = local.envoy.cert
  envoy_tls             = local.envoy.tls
  envoy_cert_auto_gen   = local.envoy.cert_auto_gen
  envoy_tag             = local.envoy.tag
  envoy_image           = local.envoy.image
  envoy_port            = local.envoy.target_port
  envoy_privileged_port = local.envoy.privileged_target_port
  enable_tdagent        = local.envoy.enable_tdagent
  custom_config_path    = local.envoy.custom_config_path
  internal_domain       = local.internal_domain
}

resource "aws_security_group" "envoy" {
  count = local.envoy.resource_count > 0 ? 1 : 0

  name        = "${local.network_name}-envoy-nodes"
  description = "Envoy Security Rules"
  vpc_id      = local.network_id

  tags = merge(
    var.custom_tags,
    {
      Name      = "${local.network_name} Envoy"
      Terraform = "true"
      Network   = local.network_name
    }
  )
}

resource "aws_security_group_rule" "envoy_ssh" {
  count = local.envoy.resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Envoy SSH"

  security_group_id = aws_security_group.envoy[count.index].id
}

resource "aws_security_group_rule" "envoy_target_port" {
  count = local.envoy.resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = local.envoy.target_port
  to_port     = local.envoy.target_port
  protocol    = "tcp"
  cidr_blocks = [local.envoy.nlb_internal ? local.network_cidr : "0.0.0.0/0"]
  description = "Envoy Target Port"

  security_group_id = aws_security_group.envoy[count.index].id
}

resource "aws_security_group_rule" "envoy_privileged_target_port" {
  count = local.envoy.resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = local.envoy.privileged_target_port
  to_port     = local.envoy.privileged_target_port
  protocol    = "tcp"
  cidr_blocks = [local.envoy.nlb_internal ? local.network_cidr : "0.0.0.0/0"]
  description = "Envoy Privileged Target Port"

  security_group_id = aws_security_group.envoy[count.index].id
}

resource "aws_security_group_rule" "envoy_node_exporter" {
  count = local.envoy.resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = 9100
  to_port     = 9100
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Envoy Prometheus Node Exporter"

  security_group_id = aws_security_group.envoy[count.index].id
}

resource "aws_security_group_rule" "envoy_exporter" {
  count = local.envoy.resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = 9001
  to_port     = 9001
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Envoy Exporter"

  security_group_id = aws_security_group.envoy[count.index].id
}

resource "aws_security_group_rule" "envoy_cadvisor" {
  count = local.envoy.resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = 18080
  to_port     = 18080
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Envoy cAdvisor"

  security_group_id = aws_security_group.envoy[count.index].id
}

resource "aws_security_group_rule" "envoy_fluentd_prometheus" {
  count = local.envoy.resource_count > 0 && local.envoy.enable_tdagent ? 1 : 0

  type        = "ingress"
  from_port   = 24231
  to_port     = 24231
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Envoy fluentd-plugin-prometheus"

  security_group_id = aws_security_group.envoy[count.index].id
}

resource "aws_security_group_rule" "envoy_egress" {
  count = local.envoy.resource_count > 0 ? 1 : 0

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "all"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Envoy Egress"

  security_group_id = aws_security_group.envoy[count.index].id
}

resource "aws_lb" "envoy_lb" {
  count = local.envoy.enable_nlb ? 1 : 0

  name               = "${local.network_name}-envoy-lb"
  internal           = local.envoy.nlb_internal
  load_balancer_type = "network"
  subnets            = local.envoy_nlb_subnet_ids

  enable_deletion_protection = false

  tags = merge(
    var.custom_tags,
    {
      Terraform = "true"
      Network   = local.network_name
      Name      = "${local.network_name} Envoy"
    }
  )
}

resource "aws_lb_target_group" "envoy_lb_target_group" {
  count = local.envoy.enable_nlb ? 1 : 0

  name     = "${local.network_name}-envoy-tg"
  port     = local.envoy.target_port
  protocol = "TCP"
  vpc_id   = local.network_id

  health_check {
    protocol            = "TCP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 10
  }
}

resource "aws_lb_target_group" "envoy_lb_privileged_target_group" {
  count = local.envoy.enable_nlb ? 1 : 0

  name     = "${local.network_name}-envoy-pv-tg"
  port     = local.envoy.privileged_target_port
  protocol = "TCP"
  vpc_id   = local.network_id

  health_check {
    protocol            = "TCP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 10
  }
}

resource "aws_lb_listener" "envoy_lb_listener" {
  count = local.envoy.enable_nlb ? 1 : 0

  load_balancer_arn = aws_lb.envoy_lb[0].arn
  port              = local.envoy.listen_port
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.envoy_lb_target_group[0].arn
  }
}

resource "aws_lb_listener" "envoy_lb_privileged_listener" {
  count = local.envoy.enable_nlb ? 1 : 0

  load_balancer_arn = aws_lb.envoy_lb[0].arn
  port              = local.envoy.privileged_listen_port
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.envoy_lb_privileged_target_group[0].arn
  }
}

resource "aws_lb_target_group_attachment" "envoy_target_group_attachments" {
  count = local.envoy.enable_nlb ? local.envoy.resource_count : 0

  target_group_arn = aws_lb_target_group.envoy_lb_target_group[0].arn
  target_id        = module.envoy_cluster.id[count.index]
  port             = local.envoy.target_port

  lifecycle {
    ignore_changes = all
  }
}

resource "aws_lb_target_group_attachment" "envoy_privileged_target_group_attachments" {
  count = local.envoy.enable_nlb ? local.envoy.resource_count : 0

  target_group_arn = aws_lb_target_group.envoy_lb_privileged_target_group[0].arn
  target_id        = module.envoy_cluster.id[count.index]
  port             = local.envoy.privileged_target_port

  lifecycle {
    ignore_changes = all
  }
}

resource "aws_route53_record" "envoy_dns_lb" {
  count = local.envoy.enable_nlb && local.envoy.nlb_internal ? 1 : 0

  zone_id = local.network_dns
  name    = "envoy-lb"
  type    = "A"

  alias {
    name                   = aws_lb.envoy_lb[0].dns_name
    zone_id                = aws_lb.envoy_lb[0].zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "envoy_dns" {
  count = local.envoy.resource_count

  zone_id = local.network_dns
  name    = "envoy-${count.index + 1}"
  type    = "A"
  ttl     = "300"
  records = [module.envoy_cluster.private_ip[count.index]]
}

resource "aws_route53_record" "envoy_exporter_dns_srv" {
  count = local.envoy.resource_count > 0 ? 1 : 0

  zone_id = local.network_dns
  name    = "_envoy-exporter._tcp.envoy"
  type    = "SRV"
  ttl     = "300"
  records = formatlist(
    "0 0 9001 %s.%s",
    aws_route53_record.envoy_dns.*.name,
    "${local.internal_domain}.",
  )
}

resource "aws_route53_record" "envoy_node_exporter_dns_srv" {
  count = local.envoy.resource_count > 0 ? 1 : 0

  zone_id = local.network_dns
  name    = "_node-exporter._tcp.envoy"
  type    = "SRV"
  ttl     = "300"
  records = formatlist(
    "0 0 9100 %s.%s",
    aws_route53_record.envoy_dns.*.name,
    "${local.internal_domain}.",
  )
}

resource "aws_route53_record" "envoy_cadvisor_dns_srv" {
  count = local.envoy.resource_count > 0 ? 1 : 0

  zone_id = local.network_dns
  name    = "_cadvisor._tcp.envoy"
  type    = "SRV"
  ttl     = "300"
  records = formatlist(
    "0 0 18080 %s.%s",
    aws_route53_record.envoy_dns.*.name,
    "${local.internal_domain}.",
  )
}

resource "aws_route53_record" "envoy_fluentd_prometheus_dns_srv" {
  count = local.envoy.resource_count > 0 && local.envoy.enable_tdagent ? 1 : 0

  zone_id = local.network_dns
  name    = "_fluentd._tcp.envoy"
  type    = "SRV"
  ttl     = "300"
  records = formatlist(
    "0 0 24231 %s.%s",
    aws_route53_record.envoy_dns.*.name,
    "${local.internal_domain}.",
  )
}
