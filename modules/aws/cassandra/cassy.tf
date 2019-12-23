module "cassy_cluster" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> v2.0"

  name           = "${local.network_name} Cassy Cluster"
  instance_count = local.cassy_resource_count

  ami                         = local.image_id
  instance_type               = local.cassy_resource_type
  key_name                    = local.key_name
  monitoring                  = false
  vpc_security_group_ids      = [aws_security_group.cassy.id]
  subnet_id                   = local.subnet_id
  associate_public_ip_address = false

  tags = {
    Terraform = true
    Network   = local.network_name
    Role      = "cassy"
  }

  root_block_device = [
    {
      volume_size           = local.cassy_resource_root_volume_size
      delete_on_termination = true
      volume_type           = "gp2"
    },
  ]
}

module "cassy_provision" {
  source           = "../../universal/cassy"
  triggers         = local.triggers
  bastion_host_ip  = local.bastion_ip
  host_list        = module.cassy_cluster.private_ip
  user_name        = local.user_name
  private_key_path = local.private_key_path
  provision_count  = local.cassy_resource_count
  enable_tdagent   = local.cassy_enable_tdagent
}

resource "aws_security_group" "cassy" {
  name        = "${local.network_name}-cassy-nodes"
  description = "cassy nodes"
  vpc_id      = local.network_id

  tags = {
    Name = "${local.network_name} cassy"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [local.network_cidr]
    self        = false
  }

  ingress {
    from_port   = 20051
    to_port     = 20051
    protocol    = "tcp"
    cidr_blocks = [local.network_cidr]
  }

  # Node Exporter
  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = [local.network_cidr]
  }

  # cAdvisor
  ingress {
    from_port   = 18080
    to_port     = 18080
    protocol    = "tcp"
    cidr_blocks = [local.network_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_route53_record" "cassy-dns" {
  count = local.cassy_resource_count

  zone_id = local.network_dns
  name    = "cassy"
  type    = "A"
  ttl     = "300"
  records = [module.cassy_cluster.private_ip[count.index]]
}

resource "aws_route53_record" "cassy-dns-srv" {
  count = local.cassy_resource_count > 0 ? 1 : 0

  zone_id = local.network_dns
  name    = "_cassy._tcp.cassy"
  type    = "SRV"
  ttl     = "300"
  records = formatlist(
    "0 0 8081 %s.%s",
    aws_route53_record.cassy-dns.*.name,
    "internal.scalar-labs.com.",
  )
}

resource "aws_route53_record" "cassy-cadvisor-dns-srv" {
  count = local.cassy_resource_count > 0 ? 1 : 0

  zone_id = local.network_dns
  name    = "_cadvisor._tcp.cassy"
  type    = "SRV"
  ttl     = "300"
  records = formatlist(
    "0 0 18080 %s.%s",
    aws_route53_record.cassy-dns.*.name,
    "internal.scalar-labs.com.",
  )
}

resource "aws_route53_record" "cassy-node-exporter-dns-srv" {
  count = local.cassy_resource_count > 0 ? 1 : 0

  zone_id = local.network_dns
  name    = "_node-exporter._tcp.cassy"
  type    = "SRV"
  ttl     = "300"
  records = formatlist(
    "0 0 9100 %s.%s",
    aws_route53_record.cassy-dns.*.name,
    "internal.scalar-labs.com.",
  )
}
