

output "api_gateway_invoke_url" {
  value = "${aws_api_gateway_stage.api_stage_env.invoke_url}/${var.endpoint_path}"
}