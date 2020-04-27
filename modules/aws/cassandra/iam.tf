resource "aws_iam_instance_profile" "cassandra" {
  name = "${local.network_name}-cassandra"
  role = aws_iam_role.cassandra.name
}

resource "aws_iam_role" "cassandra" {
  name               = "${local.network_name}-cassandra"
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

resource "aws_iam_policy" "cassandra_s3" {
  count = length(data.aws_iam_policy_document.s3) > 0 ? 1 : 0

  name   = "${local.network_name}-cassandra-s3-policy"
  policy = data.aws_iam_policy_document.s3[0].json
}

resource "aws_iam_role_policy_attachment" "cassandra" {
  count = length(aws_iam_policy.cassandra_s3) > 0 ? 1 : 0

  role       = aws_iam_role.cassandra.name
  policy_arn = aws_iam_policy.cassandra_s3[0].arn
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

data "aws_s3_bucket" "cassy_storage" {
  # If the resource_count of Cassy > 0, this resource makes local.cassy.storage_base_uri required and ensures the S3 bucket is accessible.
  count = local.cassy.resource_count > 0 ? 1 : 0

  bucket = trimprefix(local.cassy.storage_base_uri, "s3://")
}

data "aws_iam_policy_document" "s3" {
  count = length(data.aws_s3_bucket.cassy_storage) > 0 ? 1 : 0

  statement {
    actions = ["s3:ListBucket"]
    resources = [
      data.aws_s3_bucket.cassy_storage[0].arn
    ]
  }

  statement {
    actions = [
      "s3:PutObject",
      "s3:GetObject",
      "s3:DeleteObject",
      "s3:PutObjectAcl",
    ]
    resources = [
      "${data.aws_s3_bucket.cassy_storage[0].arn}/*"
    ]
  }
}
