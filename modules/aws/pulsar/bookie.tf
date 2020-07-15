module "bookie_cluster" {
  source = "github.com/scalar-labs/terraform-aws-ec2-instance?ref=7200e68"

  name           = "${local.network_name} Bookie Cluster"
  instance_count = local.bookie.resource_count

  ami                         = local.image_id
  instance_type               = local.bookie.resource_type
  key_name                    = local.key_name
  monitoring                  = false
  vpc_security_group_ids      = aws_security_group.bookie.*.id
  subnet_ids                  = local.subnet_ids
  associate_public_ip_address = false
  hostname_prefix             = "bookie"
  use_num_suffix              = true

  tags = merge(
    var.custom_tags,
    {
      Terraform = "true"
      Network   = local.network_name
      Role      = "bookie"
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
      volume_size           = local.bookie.resource_root_volume_size
      delete_on_termination = true
      volume_type           = "gp2"
    },
  ]
}

resource "aws_ebs_volume" "bookie_data_volume" {
  count = local.bookie.enable_data_volume && ! local.bookie.data_use_local_volume ? local.bookie.resource_count : 0

  availability_zone = local.locations[count.index % length(local.locations)]
  size              = local.bookie.data_remote_volume_size
  type              = local.bookie.data_remote_volume_type
  encrypted         = local.bookie.encrypt_volume

  tags = merge(
    var.custom_tags,
    {
      Name      = "${local.network_name} Bookie Cluster-${count.index + 1}"
      Terraform = "true"
      Network   = local.network_name
    }
  )
}

resource "aws_volume_attachment" "bookie_data_volume_attachment" {
  count = local.bookie.enable_data_volume && ! local.bookie.data_use_local_volume ? local.bookie.resource_count : 0

  device_name = "/dev/xvdh"
  volume_id   = aws_ebs_volume.bookie_data_volume[count.index].id
  instance_id = module.bookie_cluster.id[count.index]

  force_detach = true
}

resource "aws_security_group" "bookie" {
  count = local.bookie.resource_count > 0 ? 1 : 0

  name        = "${local.network_name}-bookie"
  description = "Bookie nodes"
  vpc_id      = local.network_id

  tags = merge(
    var.custom_tags,
    {
      Name      = "${local.network_name} Bookie"
      Terraform = "true"
      Network   = local.network_name
    }
  )
}

resource "aws_security_group_rule" "bookie_ssh" {
  count = local.bookie.resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Bookie SSH"

  security_group_id = aws_security_group.bookie[count.index].id
}

resource "aws_security_group_rule" "bookie_service" {
  count = local.bookie.resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = 3181
  to_port     = 3181
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Bookie 3181"

  security_group_id = aws_security_group.bookie[count.index].id
}

resource "aws_security_group_rule" "bookie_egress" {
  count = local.bookie.resource_count > 0 ? 1 : 0

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "all"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.bookie[count.index].id
}

resource "aws_route53_record" "bookie_dns" {
  count = local.bookie.resource_count

  zone_id = local.network_dns
  name    = "bookie-${count.index + 1}"
  type    = "A"
  ttl     = "300"
  records = [module.bookie_cluster.private_ip[count.index]]
}

resource "aws_route53_record" "bookie_exporter_dns_srv" {
  count = local.bookie.resource_count > 0 ? 1 : 0

  zone_id = local.network_dns
  name    = "_bookie-exporter._tcp.bookie"
  type    = "SRV"
  ttl     = "300"
  records = formatlist(
    "0 0 7070 %s.%s",
    aws_route53_record.bookie_dns.*.name,
    "${local.internal_domain}.",
  )
}

resource "aws_route53_record" "bookie_node_exporter_dns_srv" {
  count = local.bookie.resource_count > 0 ? 1 : 0

  zone_id = local.network_dns
  name    = "_node-exporter._tcp.bookie"
  type    = "SRV"
  ttl     = "300"
  records = formatlist(
    "0 0 9100 %s.%s",
    aws_route53_record.bookie_dns.*.name,
    "${local.internal_domain}.",
  )
}
