# data "aws_region" "current" {}

# data "aws_caller_identity" "current" {}

# data "aws_iam_policy_document" "opensearch_policy" {
#   statement {
#     effect = "Allow"

#     principals {
#       type        = "*"
#       identifiers = ["*"]
#     }

#     actions   = ["es:*"]
#     resources = ["arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.domain}/*"]
#   }
# }

# resource "aws_opensearch_domain" "opensearch_domain" {
#   domain_name = var.domain
#   engine_version = "OpenSearch_2.11"

#   cluster_config {
#     instance_type = "r6g.large.search"
#   }

#   tags = {
#     Domain = var.domain
#   }

#   access_policies = data.aws_iam_policy_document.opensearch_policy.json

#   ebs_options {
#     ebs_enabled = true
#     volume_size = 10 # GiB
#   }

#   advanced_security_options {
#     enabled                        = false
#     anonymous_auth_enabled         = true
#     internal_user_database_enabled = true
#     master_user_options {
#       master_user_name     = "testing"
#       master_user_password = "testing"
#     }
#   }
# }



