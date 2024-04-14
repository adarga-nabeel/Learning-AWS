resource "aws_ecr_repository" "main" {
  name                 = var.name  # Name of the repository
  image_tag_mutability = "MUTABLE"  # You can set this to IMMUTABLE if needed

  image_scanning_configuration {
    scan_on_push = false
  }
}

data "aws_caller_identity" "local_account_id" {}

resource "null_resource" "docker_image" {
  depends_on = [aws_ecr_repository.main]

  provisioner "local-exec" {
    command = <<-EOT
      echo '${templatefile("${path.module}/templates/deploy_to_ecr.tpl", {
        region          = var.region
        account_id      = data.aws_caller_identity.local_account_id.account_id,  # Replace with your actual AWS account ID
        repository_name = var.name
      })}' > deploy_to_ecr.sh && chmod +x deploy_to_ecr.sh && ./deploy_to_ecr.sh && rm deploy_to_ecr.sh
    EOT
  }
}