#########################################################################################################
# Archive the file (ZIP) as required by the Lambda Function
#########################################################################################################
data "archive_file" "lambda" {
  type        = "zip"
  source_dir  = "${path.module}/python/"
  output_path = "${path.module}/python/cars.zip"
}


resource "aws_lambda_function" "car_lambda" {
  filename      = "${path.module}/python/cars.zip"
  function_name = var.name
  role          = aws_iam_role.iam_for_lambda.arn

  # name of the file + function name
  handler       = "main.lambda_handler"

  source_code_hash = data.archive_file.lambda.output_base64sha256

  runtime = "python3.12"

  environment {
    variables = {
      name = var.name
      region = var.region
    }
  }
}