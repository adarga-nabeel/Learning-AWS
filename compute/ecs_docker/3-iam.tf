###############################################################################################################
# ECS TASK ROLE
###############################################################################################################
# Retrieve account ID
data "aws_caller_identity" "local_account_id" {}

resource "aws_iam_role" "task_role" {
  name = "AmazonECSTaskS3BucketRole"
 
  assume_role_policy = <<EOF
{
   "Version":"2012-10-17",
   "Statement":[
      {
         "Effect":"Allow",
         "Principal":{
            "Service":[
               "ecs-tasks.amazonaws.com"
            ]
         },
         "Action":"sts:AssumeRole",
         "Condition":{
            "ArnLike":{
            "aws:SourceArn":"arn:aws:ecs:${var.region}:${data.aws_caller_identity.local_account_id.account_id}:*"
            },
            "StringEquals":{
               "aws:SourceAccount":"${data.aws_caller_identity.local_account_id.account_id}"
            }
         }
      }
   ]
}
EOF
}

# TaskIAMPolicy - https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-iam-roles.html?icmpid=docs_ecs_hp-task-definition
data "aws_iam_policy_document" "task_policy_manifest" {
  statement {
    effect = "Allow"
    actions   = ["s3:GetObject"]
    resources = ["arn:aws:s3:::*/*"]

    condition {
      test     = "ArnLike"
      values   = ["arn:aws:ecs:${var.region}:${data.aws_caller_identity.local_account_id.account_id}:*"]
      variable = "aws:SourceArn"
    }

    condition {
      test     = "StringEquals"
      values   = ["${data.aws_caller_identity.local_account_id.account_id}"]
      variable = "aws:SourceAccount"
    }
  }
}
 
resource "aws_iam_policy" "task_policy" {
  name   = "TaskIAMPolicy"
  policy = data.aws_iam_policy_document.task_policy_manifest.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_role_policy_attachment" {
  role       = "${aws_iam_role.task_role.name}"
  policy_arn = aws_iam_policy.task_policy.arn
}


###############################################################################################################
# Task execution role
###############################################################################################################
resource "aws_iam_role" "ecs_task_execution_role" {
  name = "ecsTaskExecutionRole"
 
  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "",
            "Effect": "Allow",
            "Principal": {
                "Service": "ecs-tasks.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
