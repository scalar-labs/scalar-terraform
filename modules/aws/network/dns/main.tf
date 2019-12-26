resource "aws_route53_zone" "private" {
  name = var.internal_root_dns

  vpc {
    vpc_id = var.network_id
  }

  tags = {
    Name = "${var.network_name} DNS Zone"
  }
}

