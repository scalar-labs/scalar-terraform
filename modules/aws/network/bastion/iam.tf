resource "aws_iam_instance_profile" "bastion" {
  name = "${var.network_name}-bastion"
  role = aws_iam_role.bastion.name
}

resource "aws_iam_role" "bastion" {
  name               = "${var.network_name}-bastion"
  assume_role_policy = data.aws_iam_policy_document.assume.json

  tags = merge(
    var.custom_tags,
    {
      Terraform = "true"
      Network   = var.network_name
    }
  )
}

data "aws_iam_policy_document" "assume" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}
