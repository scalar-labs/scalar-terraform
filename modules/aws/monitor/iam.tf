data "aws_s3_bucket" "monitor_log" {
  count = local.enable_log_archive_storage && local.monitor.resource_count > 0 ? 1 : 0

  bucket = local.log_archive_storage_bucket
}

resource "aws_iam_instance_profile" "monitor" {
  name = "${local.network_name}-monitor"
  role = aws_iam_role.monitor[0].name
}

resource "aws_iam_role" "monitor" {
  count = local.monitor.resource_count > 0 ? 1 : 0

  name               = "${local.network_name}-monitor"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.assume.json

  tags = merge(
    var.custom_tags,
    {
      Terraform = "true"
      Network   = local.network_name
    }
  )
}

resource "aws_iam_policy" "monitor_s3" {
  count = local.enable_log_archive_storage && local.monitor.resource_count > 0 ? 1 : 0

  name   = "${local.network_name}-monitor-s3-policy"
  policy = data.aws_iam_policy_document.s3[count.index].json
}

resource "aws_iam_role_policy_attachment" "monitor" {
  count = local.enable_log_archive_storage && local.monitor.resource_count > 0 ? 1 : 0

  role       = aws_iam_role.monitor[0].name
  policy_arn = aws_iam_policy.monitor_s3[count.index].arn
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

data "aws_iam_policy_document" "s3" {
  count = local.enable_log_archive_storage && local.monitor.resource_count > 0 ? 1 : 0

  statement {
    actions = ["s3:ListBucket"]
    resources = [
      data.aws_s3_bucket.monitor_log[count.index].arn
    ]
  }

  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
    ]
    resources = [
      "${data.aws_s3_bucket.monitor_log[count.index].arn}/*"
    ]
  }
}
