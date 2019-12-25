module "envoy_cluster" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> v2.0"

  name           = "${local.network_name} Envoy Cluster"
  instance_count = local.envoy_resource_count

  ami                         = local.image_id
  instance_type               = local.envoy_resource_type
  key_name                    = local.key_name
  monitoring                  = false
  vpc_security_group_ids      = [aws_security_group.envoy.id]
  subnet_id                   = local.subnet_id
  associate_public_ip_address = false

  tags = {
    Terraform = true
    Network   = local.network_name
    Role      = "envoy"
  }

  root_block_device = [
    {
      volume_size           = local.envoy_resource_root_volume_size
      delete_on_termination = true
      volume_type           = "gp2"
    },
  ]
}

module "envoy_provision" {
  source              = "../../universal/envoy"
  triggers            = local.triggers
  bastion_host_ip     = local.bastion_ip
  host_list           = module.envoy_cluster.private_ip
  user_name           = local.user_name
  private_key_path    = local.private_key_path
  provision_count     = local.envoy_resource_count
  key                 = local.envoy_key
  cert                = local.envoy_cert
  envoy_tls           = local.envoy_tls
  envoy_cert_auto_gen = local.envoy_cert_auto_gen
  envoy_tag           = local.envoy_tag
  envoy_image         = local.envoy_image
  envoy_port          = local.envoy_target_port
  enable_tdagent      = local.envoy_enable_tdagent
  custom_config_path  = local.envoy_custom_config_path
}

resource "aws_security_group" "envoy" {
  name        = "${local.network_name}-envoy-nodes"
  description = "Envoy Security Rules"
  vpc_id      = local.network_id

  tags = {
    Name = "${local.network_name} Envoy"
  }
}

resource "aws_security_group_rule" "envoy_ssh" {
  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Envoy SSH"

  security_group_id = aws_security_group.envoy.id
}

resource "aws_security_group_rule" "envoy_target_port" {
  type        = "ingress"
  from_port   = local.envoy_target_port
  to_port     = local.envoy_target_port
  protocol    = "tcp"
  cidr_blocks = [local.envoy_nlb_internal ? local.network_cidr : "0.0.0.0/0"]
  description = "Envoy Target Port"

  security_group_id = aws_security_group.envoy.id
}

resource "aws_security_group_rule" "envoy_node_exporter" {
  type        = "ingress"
  from_port   = 9100
  to_port     = 9100
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Envoy Prometheus Node Exporter"

  security_group_id = aws_security_group.envoy.id
}

resource "aws_security_group_rule" "envoy_exporter" {
  type        = "ingress"
  from_port   = 9001
  to_port     = 9001
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Envoy Exporter"

  security_group_id = aws_security_group.envoy.id
}

resource "aws_security_group_rule" "envoy_cadvisor" {
  type        = "ingress"
  from_port   = 18080
  to_port     = 18080
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Envoy cAdvisor"

  security_group_id = aws_security_group.envoy.id
}

resource "aws_security_group_rule" "envoy_egress" {
  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "all"
  cidr_blocks = ["0.0.0.0/0"]
  description = "Envoy Egress"

  security_group_id = aws_security_group.envoy.id
}

resource "aws_lb" "envoy-lb" {
  count              = local.envoy_enable_nlb ? 1 : 0
  name               = "${local.network_name}-envoy-lb"
  internal           = local.envoy_nlb_internal
  load_balancer_type = "network"
  subnets            = [local.subnet_id]

  enable_deletion_protection = false
}

resource "aws_lb_target_group" "envoy-lb-target-group" {
  count    = local.envoy_enable_nlb ? 1 : 0
  name     = "${local.network_name}-envoy-tg"
  port     = local.envoy_target_port
  protocol = "TCP"
  vpc_id   = local.network_id

  health_check {
    protocol            = "TCP"
    healthy_threshold   = 2
    unhealthy_threshold = 2
    interval            = 10
  }
}

resource "aws_lb_listener" "envoy-lb-listener" {
  count             = local.envoy_enable_nlb ? 1 : 0
  load_balancer_arn = aws_lb.envoy-lb[0].arn
  port              = local.envoy_listen_port
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.envoy-lb-target-group[0].arn
  }
}

resource "aws_lb_target_group_attachment" "envoy-target-group-attachments" {
  count            = local.envoy_enable_nlb ? local.envoy_resource_count : 0
  target_group_arn = aws_lb_target_group.envoy-lb-target-group[0].arn
  target_id        = module.envoy_cluster.id[count.index]
  port             = local.envoy_target_port

  lifecycle {
    ignore_changes = all
  }
}

resource "aws_route53_record" "envoy-dns-lb" {
  count   = local.envoy_enable_nlb ? 1 : 0
  zone_id = local.network_dns
  name    = "envoy-lb"
  type    = "A"

  alias {
    name                   = aws_lb.envoy-lb[0].dns_name
    zone_id                = aws_lb.envoy-lb[0].zone_id
    evaluate_target_health = true
  }
}

resource "aws_route53_record" "envoy-dns" {
  count   = local.envoy_resource_count
  zone_id = local.network_dns
  name    = "envoy-${count.index + 1}"
  type    = "A"
  ttl     = "300"
  records = [element(module.envoy_cluster.private_ip, count.index)]
}

resource "aws_route53_record" "envoy-exporter-dns-srv" {
  count = local.envoy_resource_count > 0 ? 1 : 0

  zone_id = local.network_dns
  name    = "_envoy-exporter._tcp.envoy"
  type    = "SRV"
  ttl     = "300"
  records = formatlist(
    "0 0 9001 %s.%s",
    aws_route53_record.envoy-dns.*.name,
    "internal.scalar-labs.com.",
  )
}

resource "aws_route53_record" "envoy-node-exporter-dns-srv" {
  count = local.envoy_resource_count > 0 ? 1 : 0

  zone_id = local.network_dns
  name    = "_node-exporter._tcp.envoy"
  type    = "SRV"
  ttl     = "300"
  records = formatlist(
    "0 0 9100 %s.%s",
    aws_route53_record.envoy-dns.*.name,
    "internal.scalar-labs.com.",
  )
}

resource "aws_route53_record" "envoy-cadvisor-dns-srv" {
  count = local.envoy_resource_count > 0 ? 1 : 0

  zone_id = local.network_dns
  name    = "_cadvisor._tcp.envoy"
  type    = "SRV"
  ttl     = "300"
  records = formatlist(
    "0 0 18080 %s.%s",
    aws_route53_record.envoy-dns.*.name,
    "internal.scalar-labs.com.",
  )
}
