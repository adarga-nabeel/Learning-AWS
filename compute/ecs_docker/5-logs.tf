resource "aws_cloudwatch_log_group" "ecs_log_group" {
  name = "/ecs/${var.name}"
  retention_in_days = 30  # Optional: Set retention policy (in days)

  tags = {
    Name = var.name
  }
}


resource "aws_cloudwatch_log_stream" "ecs_log_stream" {
  name           = "${var.name}-log-stream"
  log_group_name = aws_cloudwatch_log_group.ecs_log_group.name
}