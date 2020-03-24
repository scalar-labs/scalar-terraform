resource "aws_route53_zone" "private" {
  name = var.internal_domain

  vpc {
    vpc_id = var.network_id
  }

  tags = {
    Name = "${var.network_name} DNS Zone"
  }
}

