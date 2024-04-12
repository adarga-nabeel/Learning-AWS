#####
# In this example we focus on enabling VPC Flow logs
# - VPC level: This will monitor logs for every subnet and every network interface within that VPC.
#####

resource "aws_flow_log" "main" {
  iam_role_arn    = aws_iam_role.main.arn
  log_destination = aws_cloudwatch_log_group.main.arn
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.main.id
}

resource "aws_cloudwatch_log_group" "main" {
  name = var.name
}

# Trust policy - which identities can assume this role. In this example it's the vpc flow logs.
data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["vpc-flow-logs.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

# Permission policy - what permission does the role have which will be utilised by the Trusted policy users
data "aws_iam_policy_document" "main" {
  statement {
    effect = "Allow"

    actions = [
      "logs:CreateLogGroup",
      "logs:CreateLogStream",
      "logs:PutLogEvents",
      "logs:DescribeLogGroups",
      "logs:DescribeLogStreams",
    ]

    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "main" {
  name   = var.name
  role   = aws_iam_role.main.id
  policy = data.aws_iam_policy_document.main.json
}

resource "aws_iam_role" "main" {
  name               = "main"
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}