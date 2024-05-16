#########################################################################################################
# Create the API Gateway
#########################################################################################################
resource "aws_api_gateway_rest_api" "api_gateway" {
  name = "cars-api"
  description = "Cars API Gateway"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}


#########################################################################################################
# Create API Gateway Resource to add specifications
#########################################################################################################
resource "aws_api_gateway_resource" "api_gateway_resource" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  parent_id = aws_api_gateway_rest_api.api_gateway.root_resource_id

  # “<URL>/cars"
  path_part = var.endpoint_path
}


#########################################################################################################
# Add API Gateway Request (calling) Method
#########################################################################################################
resource "aws_api_gateway_method" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.api_gateway_resource.id
  http_method = "GET"
  authorization = "NONE"
}


#########################################################################################################
# Integrating API Gateway with Lambda function in this case
#########################################################################################################
resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  resource_id = aws_api_gateway_resource.api_gateway_resource.id
  http_method = aws_api_gateway_method.proxy.http_method
  integration_http_method = "POST"

  # Informs Lambda that the API request is from AWS
  type = "AWS_PROXY"
  uri = aws_lambda_function.car_lambda.invoke_arn

}


#########################################################################################################
# Permissions to allow API Gateway to talk to Lambda Function
#########################################################################################################
data "aws_caller_identity" "account_info" {}
data "aws_region" "current" {}

resource "aws_lambda_permission" "lambda_permission" {
  statement_id  = "AllowExecutionFromAPIGateway"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.car_lambda.function_name
  principal     = "apigateway.amazonaws.com"
  source_arn    = "arn:aws:execute-api:${data.aws_region.current.id}:${data.aws_caller_identity.account_info.account_id}:${aws_api_gateway_rest_api.api_gateway.id}/*/${aws_api_gateway_method.proxy.http_method}${aws_api_gateway_resource.api_gateway_resource.path}"
}


#########################################################################################################
# Deploy the REST API Gateway
#########################################################################################################
resource "aws_api_gateway_deployment" "deploy_api_gateway" {
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id

  # triggers = {
  #   redeployment = sha1(jsonencode(aws_api_gateway_rest_api.api_gateway.body))
  # }

  lifecycle {
    create_before_destroy = true
  }
}

#########################################################################################################
# Create the Deployment staging environment
#########################################################################################################
resource "aws_api_gateway_stage" "api_stage_env" {
  deployment_id = aws_api_gateway_deployment.deploy_api_gateway.id
  rest_api_id = aws_api_gateway_rest_api.api_gateway.id
  stage_name = "development"
}

# resource "aws_api_gateway_method_response" "proxy" {
#   rest_api_id = aws_api_gateway_rest_api.api_gateway.id
#   resource_id = aws_api_gateway_resource.api_gateway_resource.id
#   http_method = aws_api_gateway_method.proxy.http_method
#   status_code = "200"
# }

# resource "aws_api_gateway_integration_response" "proxy" {
#   rest_api_id = aws_api_gateway_rest_api.api_gateway.id
#   resource_id = aws_api_gateway_resource.api_gateway_resource.id
#   http_method = aws_api_gateway_method.proxy.http_method
#   status_code = aws_api_gateway_method_response.proxy.status_code

#   depends_on = [
#     aws_api_gateway_method.proxy,
#     aws_api_gateway_integration.lambda_integration
#   ]
# }