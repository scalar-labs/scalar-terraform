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

  lifecycle {
    ignore_changes = [vpc]
  }
}
