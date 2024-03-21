
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

data "aws_iam_policy_document" "allow_public_access" {
  statement {
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.main.arn}/*"
    ]
  }
}

# UPLOAD OBJECT TO S3 BUCKET

resource "aws_s3_object" "object" {
  bucket = aws_s3_bucket.main.bucket
  key    = "site.html"
  source = "./simple.html"

  # The filemd5() function is available in Terraform 0.11.12 and later
  # For Terraform 0.11.11 and earlier, use the md5() function and the file() function:
  # etag = "${md5(file("path/to/file"))}"
  etag = filemd5("./simple.html")
}