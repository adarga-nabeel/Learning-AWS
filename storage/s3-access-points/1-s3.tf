
# CREATE A RANDOM BUCKET NAME
resource "random_string" "bucket_name" {
  length  = 16
  special = false
  upper   = false
}

resource "aws_s3_bucket" "main" {
  bucket = "my-bucket-${random_string.bucket_name.result}"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}

# ENABLE BUCKET VERSIONING
resource "aws_s3_bucket_versioning" "bucket_versioning" {
  bucket = aws_s3_bucket.main.id
  versioning_configuration {
    status = "Enabled"
  }
}

# UNBLOCK ALL PUBLIC ACCESS
resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# CREATE BUCKET POLICY AND ATTACH TO BUCKET
resource "aws_s3_bucket_policy" "allow_public_access" {
  bucket = aws_s3_bucket.main.id
  policy = data.aws_iam_policy_document.allow_public_access.json
}

# Retrieve Account ID
data "aws_caller_identity" "account_id" {}

data "aws_iam_policy_document" "allow_public_access" {

  # Create Bucket (resource) policy which will policy controls to delegate AccessPoints 
  statement {
    sid = "DelegateAccessPoint"

    principals {
      type        = "AWS"
      identifiers = ["*"] # * means everyone including anonymous public users
    }

    effect = "Allow"

    actions = [
      "*"
    ]

    resources = [
      "${aws_s3_bucket.main.arn}",
      "${aws_s3_bucket.main.arn}/*"
    ]

    condition {
      test     = "StringEquals"
      variable = "s3:DataAccessPointAccount"
      values   = [data.aws_caller_identity.account_id.account_id]
    }
  }
}

# UPLOAD OBJECT TO S3 BUCKET
resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.main.bucket
  key    = "site.html"
  source = "./simple.html"

  etag = filemd5("./simple.html")
}