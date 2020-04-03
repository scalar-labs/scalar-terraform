resource "aws_key_pair" "deploy_key" {
  key_name   = "${var.network_name}-key"
  public_key = file(var.public_key_path)
}

module "bastion_cluster" {
  source = "github.com/scalar-labs/terraform-aws-ec2-instance?ref=7200e68"

  name           = "${var.network_name} Bastion"
  instance_count = var.resource_count

  ami                         = var.image_id
  instance_type               = var.resource_type
  key_name                    = aws_key_pair.deploy_key.key_name
  monitoring                  = false
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  subnet_id                   = var.subnet_id
  associate_public_ip_address = true
  hostname_prefix             = "bastion"

  tags = merge(
    var.custom_tags,
    {
      Terraform = true
      Trigger   = var.trigger
      Network   = var.network_name
      Role      = "bastion"
    }
  )

  root_block_device = [
    {
      volume_size           = var.resource_root_volume_size
      delete_on_termination = true
      volume_type           = "gp2"
    },
  ]
}

module "bastion_provision" {
  source           = "../../../universal/bastion"
  triggers         = module.bastion_cluster.id
  bastion_host_ips = module.bastion_cluster.public_ip
  user_name        = var.user_name
  private_key_path = var.private_key_path
  provision_count  = var.resource_count
  enable_tdagent   = var.enable_tdagent
  internal_domain  = var.internal_domain
}

resource "aws_security_group" "bastion" {
  name        = "${var.network_name}_bastion_security_group"
  description = "${var.network_name} bastion security group for provisioning"
  vpc_id      = var.network_id

  tags = merge(
    var.custom_tags,
    {
      Name = "${var.network_name} Bastion"
    }
  )

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = [var.bastion_access_cidr]
  }

  # Node Exporter
  ingress {
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
    cidr_blocks = [var.network_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_route53_record" "bastion-dns" {
  count = var.resource_count

  zone_id = var.network_dns
  name    = "bastion"
  type    = "A"
  ttl     = "300"
  records = [module.bastion_cluster.private_ip[count.index]]
}

resource "aws_route53_record" "node-exporter-dns-srv" {
  count = var.resource_count > 0 ? 1 : 0

  zone_id = var.network_dns
  name    = "_node-exporter._tcp.bastion"
  type    = "SRV"
  ttl     = "300"
  records = formatlist(
    "0 0 9100 %s.%s",
    aws_route53_record.bastion-dns.*.name,
    "${var.internal_domain}.",
  )
}
