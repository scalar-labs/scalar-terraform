module "monitor_cluster" {
  source = "github.com/scalar-labs/terraform-aws-ec2-instance?ref=6a2b26c"

  name           = "${local.network_name} Monitor Cluster"
  instance_count = local.monitor.resource_count

  ami                         = local.image_id
  instance_type               = local.monitor.resource_type
  key_name                    = local.key_name
  monitoring                  = false
  vpc_security_group_ids      = aws_security_group.monitor.*.id
  subnet_ids                  = local.subnet_ids
  associate_public_ip_address = false
  hostname_prefix             = "monitor"
  use_num_suffix              = true
  iam_instance_profile        = aws_iam_instance_profile.monitor.name

  tags = merge(
    var.custom_tags,
    {
      Terraform = "true"
      Network   = local.network_name
      Role      = "monitor"
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
      volume_size           = local.monitor.resource_root_volume_size
      delete_on_termination = true
      volume_type           = "gp2"
    },
  ]
}

resource "aws_ebs_volume" "monitor_log_volume" {
  count = local.monitor.enable_tdagent ? local.monitor.resource_count : 0

  availability_zone = local.locations[count.index % length(local.locations)]
  size              = local.monitor.log_volume_size
  type              = local.monitor.log_volume_type
  encrypted         = local.monitor.encrypt_volume

  tags = merge(
    var.custom_tags,
    {
      Name      = "${local.network_name} Monitor Cluster-${count.index + 1}"
      Terraform = "true"
      Network   = local.network_name
    }
  )
}

resource "aws_volume_attachment" "monitor_log_volume_attachment" {
  count = local.monitor.enable_tdagent ? local.monitor.resource_count : 0

  device_name = "/dev/xvdh"
  volume_id   = aws_ebs_volume.monitor_log_volume[count.index].id
  instance_id = module.monitor_cluster.id[count.index]

  force_detach = true
}

resource "null_resource" "volume_data" {
  count = local.monitor.enable_tdagent ? local.monitor.resource_count : 0

  triggers = {
    volume_attachment_ids = join(
      ",",
      aws_volume_attachment.monitor_log_volume_attachment.*.id
    )
  }

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
  vm_ids           = module.monitor_cluster.id
  triggers         = concat(local.triggers, null_resource.volume_data.*.id)
  bastion_host_ip  = local.bastion_ip
  host_list        = module.monitor_cluster.private_ip
  user_name        = local.user_name
  private_key_path = local.private_key_path
  provision_count  = local.monitor.resource_count

  slack_webhook_url                     = var.slack_webhook_url
  network_id                            = local.network_id
  scalardl_blue_resource_count          = local.scalardl_blue_resource_count
  scalardl_green_resource_count         = local.scalardl_green_resource_count
  cassandra_resource_count              = local.cassandra_resource_count
  replication_factor                    = local.scalardl_replication_factor
  network_name                          = local.network_name
  enable_tdagent                        = local.monitor.enable_tdagent
  internal_domain                       = local.internal_domain
  targets                               = var.targets
  log_retention_period_days             = local.monitor.log_retention_period_days
  log_archive_storage_info              = local.log_archive_storage_info
  prometheus_data_retention_period_days = local.monitor.prometheus_data_retention_period_days
}

resource "aws_security_group" "monitor" {
  count = local.monitor.resource_count > 0 ? 1 : 0

  name        = "${local.network_name}-monitor-nodes"
  description = "Monitor nodes"
  vpc_id      = local.network_id

  tags = merge(
    var.custom_tags,
    {
      Name      = "${local.network_name} monitor"
      Terraform = "true"
      Network   = local.network_name
    }
  )
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

resource "aws_route53_record" "monitor_cluster_dns" {
  count = local.monitor.resource_count > 0 ? 1 : 0

  zone_id = local.network_dns
  name    = "monitor"
  type    = "A"
  ttl     = "300"
  records = [module.monitor_cluster.private_ip[local.monitor.active_offset]]
}

resource "aws_route53_record" "monitor_host_dns" {
  count = local.monitor.resource_count

  zone_id = local.network_dns
  name    = "monitor-${count.index + 1}"
  type    = "A"
  ttl     = "300"
  records = [module.monitor_cluster.private_ip[count.index]]
}

resource "aws_route53_record" "cadvisor_dns_srv" {
  count = local.monitor.resource_count > 0 ? 1 : 0

  zone_id = local.network_dns
  name    = "_cadvisor._tcp.monitor"
  type    = "SRV"
  ttl     = "300"
  records = formatlist(
    "0 0 18080 %s.%s",
    aws_route53_record.monitor_host_dns.*.name,
    "${local.internal_domain}.",
  )
}

resource "aws_route53_record" "node_exporter_dns_srv" {
  count = local.monitor.resource_count > 0 ? 1 : 0

  zone_id = local.network_dns
  name    = "_node-exporter._tcp.monitor"
  type    = "SRV"
  ttl     = "300"
  records = formatlist(
    "0 0 9100 %s.%s",
    aws_route53_record.monitor_host_dns.*.name,
    "${local.internal_domain}.",
  )
}
