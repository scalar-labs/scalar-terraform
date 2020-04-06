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
  subnet_ids                = local.blue_subnet_ids
  image_id                  = local.image_id
  key_name                  = local.key_name
  network_dns               = local.network_dns
  scalardl_image_name       = local.scalardl.blue_image_name
  scalardl_image_tag        = local.scalardl.blue_image_tag
  replication_factor        = local.scalardl.replication_factor
  enable_tdagent            = local.scalardl.enable_tdagent
  internal_domain           = local.internal_domain
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
  subnet_ids                = local.green_subnet_ids
  image_id                  = local.image_id
  key_name                  = local.key_name
  network_dns               = local.network_dns
  scalardl_image_name       = local.scalardl.green_image_name
  scalardl_image_tag        = local.scalardl.green_image_tag
  replication_factor        = local.scalardl.replication_factor
  enable_tdagent            = local.scalardl.enable_tdagent
  internal_domain           = local.internal_domain
}

resource "aws_security_group" "scalardl" {
  count = local.scalardl.green_resource_count > 0 || local.scalardl.blue_resource_count > 0 ? 1 : 0

  name        = "${local.network_name}-scalardl-nodes"
  description = "Scalar DL Security Rules"
  vpc_id      = local.network_id

  tags = {
    Name = "${local.network_name} Scalar DL"
  }
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
  cidr_blocks = [local.scalardl.nlb_internal ? local.network_cidr : "0.0.0.0/0"]
  description = "Scalar DL Target Port"

  security_group_id = aws_security_group.scalardl[count.index].id
}

resource "aws_security_group_rule" "scalardl_privileged_port" {
  count = local.scalardl.green_resource_count > 0 || local.scalardl.blue_resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = local.scalardl.privileged_target_port
  to_port     = local.scalardl.privileged_target_port
  protocol    = "tcp"
  cidr_blocks = [local.scalardl.nlb_internal ? local.network_cidr : "0.0.0.0/0"]
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

resource "aws_lb" "scalardl-lb" {
  count = local.scalardl.enable_nlb ? 1 : 0

  name               = "${local.network_name}-sdl-lb"
  internal           = local.scalardl.nlb_internal
  load_balancer_type = "network"
  subnets            = local.scalardl_nlb_subnet_ids

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "scalardl-lb-target-group" {
  count = local.scalardl.enable_nlb ? 1 : 0

  name     = "${local.network_name}-sdl-tg"
  port     = local.scalardl.target_port
  protocol = "TCP"
  vpc_id   = local.network_id

  health_check {
    protocol            = "TCP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 10
  }
}

resource "aws_lb_target_group" "scalardl-privileged-lb-target-group" {
  count = local.scalardl.enable_nlb ? 1 : 0

  name     = "${local.network_name}-sdl-pr-tg"
  port     = local.scalardl.privileged_target_port
  protocol = "TCP"
  vpc_id   = local.network_id

  health_check {
    protocol            = "TCP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 10
  }
}

resource "aws_lb_target_group_attachment" "scalardl-blue" {
  count = local.scalardl.enable_nlb && local.scalardl.blue_resource_count > 0 ? local.scalardl.blue_resource_count : 0

  target_group_arn = aws_lb_target_group.scalardl-lb-target-group[0].id
  target_id        = module.scalardl_blue.id[count.index]
  port             = local.scalardl.target_port

  lifecycle {
    ignore_changes = all
  }
}

resource "aws_lb_target_group_attachment" "scalardl-green" {
  count = local.scalardl.enable_nlb && local.scalardl.green_resource_count > 0 ? local.scalardl.green_resource_count : 0

  target_group_arn = aws_lb_target_group.scalardl-lb-target-group[0].id
  target_id        = module.scalardl_green.id[count.index]
  port             = local.scalardl.target_port

  lifecycle {
    ignore_changes = all
  }
}

resource "aws_lb_target_group_attachment" "scalardl-blue-privileged" {
  count = local.scalardl.enable_nlb && local.scalardl.blue_resource_count > 0 ? local.scalardl.blue_resource_count : 0

  target_group_arn = aws_lb_target_group.scalardl-privileged-lb-target-group[0].id
  target_id        = module.scalardl_blue.id[count.index]
  port             = local.scalardl.privileged_target_port

  lifecycle {
    ignore_changes = all
  }
}

resource "aws_lb_target_group_attachment" "scalardl-green-privileged" {
  count = local.scalardl.enable_nlb && local.scalardl.green_resource_count > 0 ? local.scalardl.green_resource_count : 0

  target_group_arn = aws_lb_target_group.scalardl-privileged-lb-target-group[0].id
  target_id        = module.scalardl_green.id[count.index]
  port             = local.scalardl.privileged_target_port

  lifecycle {
    ignore_changes = all
  }
}

resource "aws_lb_listener" "scalardl-lb-listener" {
  count = local.scalardl.enable_nlb ? 1 : 0

  load_balancer_arn = aws_lb.scalardl-lb[count.index].arn
  port              = local.scalardl.listen_port
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.scalardl-lb-target-group[count.index].arn
  }
}

resource "aws_lb_listener" "scalardl-privileged-lb-listener" {
  count = local.scalardl.enable_nlb ? 1 : 0

  load_balancer_arn = aws_lb.scalardl-lb[count.index].arn
  port              = local.scalardl.privileged_listen_port
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.scalardl-privileged-lb-target-group[count.index].arn
  }
}

resource "aws_route53_record" "scalardl-dns-lb" {
  count = local.scalardl.enable_nlb ? 1 : 0

  zone_id = local.network_dns
  name    = "scalardl-lb"
  type    = "A"

  alias {
    name                   = aws_lb.scalardl-lb[count.index].dns_name
    zone_id                = aws_lb.scalardl-lb[count.index].zone_id
    evaluate_target_health = true
  }
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
