
# CREATE A RANDOM BUCKET NAME
resource "random_string" "bucket_name" {
  length  = 16
  special = false
  upper   = false
}

resource "aws_s3_bucket" "main" {
  bucket = "static-website-${random_string.bucket_name.result}"

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
  # One or more statements can be created - granuler restrictions
  statement {
    # Optional identifier which can be used as a description for the policy
    sid = "PublicBucket"

    # Determins who this policy applies to
    principals {
      type        = "AWS"
      identifiers = ["*"] # * means everyone including anonymous public users
    }

    # Determins whether you're allowing/Denying the principals/user
    effect = "Allow"

    # What the principal/user is allowed to do e.g. get buckets objects
    actions = [
      "s3:GetObject"
    ]

    # Specific ARN of the specific resources this policy applies on
    resources = [
      "${aws_s3_bucket.main.arn}/*"
    ]
  }
}

# UPLOAD OBJECT TO S3 BUCKET
resource "aws_s3_object" "object" {
  # lists all files - fileset(path, pattern)
  for_each = fileset("./upload_files", "*")

  bucket = aws_s3_bucket.main.bucket

  # Name of files to be given in the bucket
  key = each.value
  # Location of local files
  source = "./upload_files/${each.value}"

  # Triggers an update when the file is updated
  etag = filemd5("./upload_files/${each.value}")
}


# Enable static hosting
resource "aws_s3_bucket_website_configuration" "example" {
  bucket = aws_s3_bucket.main.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}