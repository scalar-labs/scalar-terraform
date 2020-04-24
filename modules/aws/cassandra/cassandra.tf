module "cassandra_cluster" {
  source = "github.com/scalar-labs/terraform-aws-ec2-instance?ref=7200e68"

  name           = "${local.network_name} Cassandra Cluster"
  instance_count = local.cassandra.resource_count

  ami                         = local.image_id
  instance_type               = local.cassandra.resource_type
  key_name                    = local.key_name
  monitoring                  = false
  vpc_security_group_ids      = aws_security_group.cassandra.*.id
  subnet_id                   = local.subnet_id
  associate_public_ip_address = false
  hostname_prefix             = "cassandra"
  iam_instance_profile        = aws_iam_instance_profile.cassandra.name
  use_num_suffix              = true

  tags = merge(
    var.custom_tags,
    {
      Terraform = "true"
      Network   = local.network_name
      Role      = "cassandra"
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
      volume_size           = local.cassandra.resource_root_volume_size
      delete_on_termination = true
      volume_type           = "gp2"
    },
  ]
}

resource "aws_ebs_volume" "cassandra_data_volume" {
  count = local.cassandra.enable_data_volume && ! local.cassandra.data_use_local_volume ? local.cassandra.resource_count : 0

  availability_zone = local.location
  size              = local.cassandra.data_remote_volume_size
  type              = local.cassandra.data_remote_volume_type

  tags = merge(
    var.custom_tags,
    {
      Name      = "${local.network_name} Cassandra Cluster-${count.index + 1}"
      Terraform = "true"
      Network   = local.network_name
    }
  )
}

resource "aws_volume_attachment" "cassandra_data_volume_attachment" {
  count = local.cassandra.enable_data_volume && ! local.cassandra.data_use_local_volume ? local.cassandra.resource_count : 0

  device_name = "/dev/xvdh"
  volume_id   = aws_ebs_volume.cassandra_data_volume[count.index].id
  instance_id = module.cassandra_cluster.id[count.index]

  force_detach = true
}

resource "null_resource" "volume_data" {
  count = local.cassandra.enable_data_volume && ! local.cassandra.data_use_local_volume ? local.cassandra.resource_count : 0

  triggers = {
    triggers = module.cassandra_cluster.id[count.index]
  }

  connection {
    bastion_host = local.bastion_ip
    host         = module.cassandra_cluster.private_ip[count.index]
    user         = local.user_name
    agent        = true
    private_key  = file(local.private_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sh -c 'echo export DATA_STORE=${aws_ebs_volume.cassandra_data_volume[count.index].id} >> /etc/profile.d/volumes.sh'",
    ]
  }
}

resource "null_resource" "volume_data_local" {
  count = local.cassandra.enable_data_volume && local.cassandra.data_use_local_volume ? local.cassandra.resource_count : 0

  triggers = {
    triggers = module.cassandra_cluster.id[count.index]
  }

  connection {
    bastion_host = local.bastion_ip
    host         = module.cassandra_cluster.private_ip[count.index]
    user         = local.user_name
    agent        = true
    private_key  = file(local.private_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sh -c 'echo export DATA_STORE=local >> /etc/profile.d/volumes.sh'",
    ]
  }
}

resource "aws_ebs_volume" "cassandra_commitlog_volume" {
  count = local.cassandra.enable_commitlog_volume && ! local.cassandra.commitlog_use_local_volume ? local.cassandra.resource_count : 0

  availability_zone = local.location
  size              = local.cassandra.commitlog_remote_volume_size
  type              = local.cassandra.commitlog_remote_volume_type

  tags = merge(
    var.custom_tags,
    {
      Name      = "${local.network_name} Cassandra Cluster-${count.index + 1}"
      Terraform = "true"
      Network   = local.network_name
    }
  )
}

resource "aws_volume_attachment" "cassandra_commitlog_volume_attachment" {
  count = local.cassandra.enable_commitlog_volume && ! local.cassandra.commitlog_use_local_volume ? local.cassandra.resource_count : 0

  device_name = "/dev/xvdi"
  volume_id   = aws_ebs_volume.cassandra_commitlog_volume[count.index].id
  instance_id = module.cassandra_cluster.id[count.index]

  force_detach = true
}

resource "null_resource" "volume_commitlog" {
  count = local.cassandra.enable_commitlog_volume && ! local.cassandra.commitlog_use_local_volume ? local.cassandra.resource_count : 0

  triggers = {
    triggers = module.cassandra_cluster.id[count.index]
  }

  connection {
    bastion_host = local.bastion_ip
    host         = module.cassandra_cluster.private_ip[count.index]
    user         = local.user_name
    agent        = true
    private_key  = file(local.private_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sh -c 'echo export COMMIT_STORE=${aws_ebs_volume.cassandra_commitlog_volume[count.index].id}  >> /etc/profile.d/volumes.sh'",
    ]
  }
}

resource "null_resource" "volume_commitlog_local" {
  count = local.cassandra.enable_commitlog_volume && local.cassandra.commitlog_use_local_volume ? local.cassandra.resource_count : 0

  triggers = {
    triggers = module.cassandra_cluster.id[count.index]
  }

  connection {
    bastion_host = local.bastion_ip
    host         = module.cassandra_cluster.private_ip[count.index]
    user         = local.user_name
    agent        = true
    private_key  = file(local.private_key_path)
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sh -c 'echo export COMMIT_STORE=local >> /etc/profile.d/volumes.sh'",
    ]
  }
}

module "cassandra_provision" {
  source                = "../../universal/cassandra"
  vm_ids                = module.cassandra_cluster.id
  triggers              = local.triggers
  bastion_host_ip       = local.bastion_ip
  host_list             = module.cassandra_cluster.private_ip
  host_seed_list        = local.cassandra.resource_count > 0 ? slice(module.cassandra_cluster.private_ip, 0, min(local.cassandra.resource_count, 3)) : []
  user_name             = local.user_name
  private_key_path      = local.private_key_path
  provision_count       = local.cassandra.resource_count
  enable_tdagent        = local.cassandra.enable_tdagent
  memtable_threshold    = local.cassandra.memtable_threshold
  cassy_public_key      = module.cassy_provision.public_key
  start_on_initial_boot = local.cassandra.start_on_initial_boot
  internal_domain       = local.internal_domain
}

resource "aws_security_group" "cassandra" {
  count = local.cassandra.resource_count > 0 ? 1 : 0

  name        = "${local.network_name}-cassandra-nodes"
  description = "Cassandra nodes"
  vpc_id      = local.network_id

  tags = merge(
    var.custom_tags,
    {
      Name      = "${local.network_name} Cassandra"
      Terraform = "true"
      Network   = local.network_name
    }
  )
}

resource "aws_security_group_rule" "cassandra_ssh" {
  count = local.cassandra.resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Cassandra SSH"

  security_group_id = aws_security_group.cassandra[count.index].id
}

resource "aws_security_group_rule" "cassandra_jmx" {
  count = local.cassandra.resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = 7199
  to_port     = 7199
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Cassandra JMX"

  security_group_id = aws_security_group.cassandra[count.index].id
}

resource "aws_security_group_rule" "cassandra_jmx_self" {
  count = local.cassandra.resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = 7199
  to_port     = 7199
  protocol    = "tcp"
  self        = true
  description = "Cassandra JMX Self"

  security_group_id = aws_security_group.cassandra[count.index].id
}

resource "aws_security_group_rule" "cassandra_internode" {
  count = local.cassandra.resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = 7000
  to_port     = 7001
  protocol    = "tcp"
  self        = true
  description = "Cassandra internode communication"

  security_group_id = aws_security_group.cassandra[count.index].id
}

resource "aws_security_group_rule" "cassandra_cql" {
  count = local.cassandra.resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = 9042
  to_port     = 9042
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Cassandra CQL"

  security_group_id = aws_security_group.cassandra[count.index].id
}

resource "aws_security_group_rule" "cassandra_cql_self" {
  count = local.cassandra.resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = 9042
  to_port     = 9042
  protocol    = "tcp"
  self        = true
  description = "Cassandra CQL Self"

  security_group_id = aws_security_group.cassandra[count.index].id
}

resource "aws_security_group_rule" "cassandra_exporter" {
  count = local.cassandra.resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = 7070
  to_port     = 7070
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Cassandra Exporter"

  security_group_id = aws_security_group.cassandra[count.index].id
}

resource "aws_security_group_rule" "cassandra_node_exporter" {
  count = local.cassandra.resource_count > 0 ? 1 : 0

  type        = "ingress"
  from_port   = 9100
  to_port     = 9100
  protocol    = "tcp"
  cidr_blocks = [local.network_cidr]
  description = "Cassandra Prometheus Node Exporter"

  security_group_id = aws_security_group.cassandra[count.index].id
}

resource "aws_security_group_rule" "cassandra_egress" {
  count = local.cassandra.resource_count > 0 ? 1 : 0

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "all"
  cidr_blocks = ["0.0.0.0/0"]

  security_group_id = aws_security_group.cassandra[count.index].id
}

resource "aws_route53_record" "cassandra-dns-lb" {
  count = local.cassandra.resource_count > 0 ? 1 : 0

  zone_id = local.network_dns
  name    = "cassandra-lb"
  type    = "A"
  ttl     = "300"
  records = module.cassandra_cluster.private_ip
}

resource "aws_route53_record" "cassandra-dns" {
  count = local.cassandra.resource_count

  zone_id = local.network_dns
  name    = "cassandra-${count.index + 1}"
  type    = "A"
  ttl     = "300"
  records = [module.cassandra_cluster.private_ip[count.index]]
}

resource "aws_route53_record" "cassandra-exporter-dns-srv" {
  count = local.cassandra.resource_count > 0 ? 1 : 0

  zone_id = local.network_dns
  name    = "_cassandra-exporter._tcp.cassandra"
  type    = "SRV"
  ttl     = "300"
  records = formatlist(
    "0 0 7070 %s.%s",
    aws_route53_record.cassandra-dns.*.name,
    "${local.internal_domain}.",
  )
}

resource "aws_route53_record" "node-exporter-dns-srv" {
  count = local.cassandra.resource_count > 0 ? 1 : 0

  zone_id = local.network_dns
  name    = "_node-exporter._tcp.cassandra"
  type    = "SRV"
  ttl     = "300"
  records = formatlist(
    "0 0 9100 %s.%s",
    aws_route53_record.cassandra-dns.*.name,
    "${local.internal_domain}.",
  )
}
