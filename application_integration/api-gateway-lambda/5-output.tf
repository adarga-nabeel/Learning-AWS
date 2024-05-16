

output "api_gateway_access_url" {
  value = "${aws_api_gateway_stage.api_stage_env.invoke_url}/${var.endpoint_path}"
}