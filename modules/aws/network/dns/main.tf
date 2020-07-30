resource "aws_route53_zone" "private" {
  name = var.internal_domain

  vpc {
    vpc_id = var.network_id
  }

  tags = merge(
    var.custom_tags,
    {
      Name      = "${var.network_name} DNS Zone"
      Terraform = "true"
      Network   = var.network_name
    }
  )
}

resource "aws_route53_zone_association" "custom" {
  count = length(var.custom_vpc_ids)

  zone_id = aws_route53_zone.private.zone_id
  vpc_id  = var.custom_vpc_ids[count.index]
}
