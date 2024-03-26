# Create an access point
resource "aws_s3_access_point" "main" {
  bucket = aws_s3_bucket.main.id
  name   = "developer" # any random name
}

# Access Point Policy
resource "aws_s3control_access_point_policy" "example" {
  access_point_arn = aws_s3_access_point.main.arn
  policy           = data.aws_iam_policy_document.developer_access_point_policy.json
}

# Retrive region
data "aws_region" "current" {}

data "aws_iam_policy_document" "developer_access_point_policy" {

  # Assuming IAM user called cloud_user
  # Create Bucket (resource) policy which will policy controls to delegate AccessPoints 
  statement {
    sid = "DelegateAccessPoint"

    principals {
      type        = "AWS"
      identifiers = ["arn:aws:iam::${data.aws_caller_identity.account_id.account_id}:user/cloud_user"]
    }

    effect = "Allow"

    actions = [
      "s3:GetObject",
      "s3:PutObject",
      "s3:ListBucket"
    ]

    # Allow all users with this access point
    resources = [
      "arn:aws:s3:${data.aws_region.current.name}:${data.aws_caller_identity.account_id.account_id}:accesspoint/${aws_s3_access_point.main.name}/object/*",
      "arn:aws:s3:${data.aws_region.current.name}:${data.aws_caller_identity.account_id.account_id}:accesspoint/${aws_s3_access_point.main.name}"
    ]
  }
}