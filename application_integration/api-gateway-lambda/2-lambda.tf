#########################################################################################################
# Archive the file (ZIP) as required by the Lambda Function
#########################################################################################################
data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "${path.module}/python/"
  output_path = "${path.module}/python/${var.endpoint_path}.zip"
}


resource "aws_lambda_function" "storage_lambda" {
  filename      = "${path.module}/python/${var.endpoint_path}.zip"
  function_name = var.name
  role          = aws_iam_role.iam_for_lambda.arn

  # name of the file + function name
  handler       = "main.lambda_handler"

  # Used to trigger updates.
  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.12"

  # environment variables that are accessible from the function code during execution
  environment {
    variables = {
      name = var.name
      region = var.region
    }
  }
}