module "monitor_cluster" {
  source = "git@github.com:scalar-labs/terraform-aws-ec2-instance.git?ref=1f21a9c"

  name           = "${local.network_name} Monitor Cluster"
  instance_count = local.monitor.resource_count

  ami                         = local.image_id
  instance_type               = local.monitor.resource_type
  key_name                    = local.key_name
  monitoring                  = false
  vpc_security_group_ids      = aws_security_group.monitor.*.id
  subnet_id                   = local.subnet_id
  associate_public_ip_address = false

  tags = {
    Terraform = true
    Network   = local.network_name
    Role      = "monitor"
  }

  root_block_device = [
    {
      volume_size           = local.monitor.resource_root_volume_size
      delete_on_termination = true
      volume_type           = "gp2"
    },
  ]
}

resource "aws_ebs_volume" "monitor_log_volume" {
  count = local.monitor.enable_tdagent && local.monitor.enable_log_volume ? local.monitor.resource_count : 0

  availability_zone = module.monitor_cluster.availability_zone[count.index]
  size              = local.monitor.log_volume_size
  type              = local.monitor.log_volume_type
  depends_on        = [module.monitor_cluster]
}

resource "aws_volume_attachment" "monitor_log_volume_attachment" {
  count = local.monitor.enable_tdagent && local.monitor.enable_log_volume ? local.monitor.resource_count : 0

  device_name = "/dev/xvdh"
  volume_id   = aws_ebs_volume.monitor_log_volume[count.index].id
  instance_id = module.monitor_cluster.id[count.index]

  force_detach = true
}

resource "null_resource" "volume_data" {
  count = local.monitor.enable_tdagent && local.monitor.enable_log_volume ? local.monitor.resource_count : 0

  connection {
    bastion_host = local.bastion_ip
    host         = module.monitor_cluster.private_ip[count.index]
    user         = local.user_name
    agent        = true
    private_key  = file(local.private_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sh -c 'echo export LOG_STORE=${aws_ebs_volume.monitor_log_volume.*.id[count.index]} > /etc/profile.d/volumes.sh'",
    ]
  }
}

module "monitor_provision" {
  source           = "../../universal/monitor"
  triggers         = local.triggers
  bastion_host_ip  = local.bastion_ip
  host_list        = module.monitor_cluster.private_ip
  user_name        = local.user_name
  private_key_path = local.private_key_path
  provision_count  = local.monitor.resource_count

  slack_webhook_url             = var.slack_webhook_url
  network_id                    = local.network_id
  scalardl_blue_resource_count  = local.scalardl_blue_resource_count
  scalardl_green_resource_count = local.scalardl_green_resource_count
  cassandra_resource_count      = local.cassandra_resource_count
  replication_factor            = local.scalardl_replication_factor
  network_name                  = local.network_name
  enable_tdagent                = local.monitor.enable_tdagent
  internal_root_dns             = local.internal_root_dns
}

resource "aws_security_group" "monitor" {
  count = local.monitor.resource_count > 0 ? 1 : 0

  name        = "${local.network_name}-monitor-nodes"
  description = "Monitor nodes"
  vpc_id      = local.network_id

  tags = {
    Name = "${local.network_name} monitor"
  }
}

resource "aws_security_group_rule" "monitor_ssh" {
  count = local.monitor.resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Monitor SSH"

  security_group_id = aws_security_group.monitor[count.index].id
}

resource "aws_security_group_rule" "monitor_prometheus" {
  count = local.monitor.resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = 9090
  to_port     = 9090
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Monitor Prometheus"

  security_group_id = aws_security_group.monitor[count.index].id
}

resource "aws_security_group_rule" "monitor_alertmanager" {
  count = local.monitor.resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = 9093
  to_port     = 9093
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Monitor Alertmanager"

  security_group_id = aws_security_group.monitor[count.index].id
}

resource "aws_security_group_rule" "monitor_grafana" {
  count = local.monitor.resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = 3000
  to_port     = 3000
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Monitor Grafana"

  security_group_id = aws_security_group.monitor[count.index].id
}

resource "aws_security_group_rule" "monitor_node_exporter" {
  count = local.monitor.resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = 9100
  to_port     = 9100
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Monitor Prometheus Node Exporter"

  security_group_id = aws_security_group.monitor[count.index].id
}

resource "aws_security_group_rule" "monitor_fluentd_tcp" {
  count = local.monitor.resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = 24224
  to_port     = 24224
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Monitor Fluentd aggregation TCP"

  security_group_id = aws_security_group.monitor[count.index].id
}

resource "aws_security_group_rule" "monitor_fluentd_udp" {
  count = local.monitor.resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = 24224
  to_port     = 24224
  protocol    = "udp"
  cidr_blocks = [local.network_cidr]
  description = "Monitor Fluentd aggregation UDP"

  security_group_id = aws_security_group.monitor[count.index].id
}

resource "aws_security_group_rule" "monitor_nginx" {
  count = local.monitor.resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = 80
  to_port     = 80
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Monitor Nginx"

  security_group_id = aws_security_group.monitor[count.index].id
}

resource "aws_security_group_rule" "monitor_egress" {
  count = local.monitor.resource_count > 0 ? 1 : 0

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "all"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.monitor[count.index].id
}

resource "aws_route53_record" "monitor-dns" {
  count = local.monitor.resource_count

  zone_id = local.network_dns
  name    = "monitor"
  type    = "A"
  ttl     = "300"
  records = [module.monitor_cluster.private_ip[count.index]]
}

resource "aws_route53_record" "prometheus-dns" {
  count = local.monitor.resource_count

  zone_id = local.network_dns
  name    = "prometheus"
  type    = "A"
  ttl     = "300"
  records = [module.monitor_cluster.private_ip[count.index]]
}

resource "aws_route53_record" "cadvisor-dns-srv" {
  count = local.monitor.resource_count > 0 ? 1 : 0

  zone_id = local.network_dns
  name    = "_cadvisor._tcp.monitor"
  type    = "SRV"
  ttl     = "300"
  records = formatlist(
    "0 0 18080 %s.%s",
    aws_route53_record.monitor-dns.*.name,
    "${local.internal_root_dns}.",
  )
}

resource "aws_route53_record" "node-exporter-dns-srv" {
  count = local.monitor.resource_count > 0 ? 1 : 0

  zone_id = local.network_dns
  name    = "_node-exporter._tcp.monitor"
  type    = "SRV"
  ttl     = "300"
  records = formatlist(
    "0 0 9100 %s.%s",
    aws_route53_record.monitor-dns.*.name,
    "${local.internal_root_dns}.",
  )
}
