data "aws_ami" "image" {
  most_recent = var.most_recent
  owners      = var.owners

  filter {
    name   = "name"
    values = [var.name]
  }
}
