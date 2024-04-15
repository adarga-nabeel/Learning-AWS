# We must first ZIP the application before deploying it to Lambda
data "archive_file" "zip_the_python_code" {
  type        = "zip"
  source_dir  = "${path.module}/python/"
  output_path = "${path.module}/python/hello-python.zip"
}

# Lambda function
resource "aws_lambda_function" "terraform_lambda_func" {
  filename                       = "${path.module}/python/hello-python.zip"
  function_name                  = "${var.name}_Test_Lambda_Function"
  role                           = aws_iam_role.lambda_role.arn
  handler                        = "index.lambda_handler"
  runtime                        = "python3.8"
  depends_on                     = [aws_iam_role_policy_attachment.attach_iam_policy_to_iam_role]
}