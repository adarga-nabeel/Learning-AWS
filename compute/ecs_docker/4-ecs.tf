resource "aws_ecs_cluster" "main" {
    name = var.name
}

resource "aws_ecs_task_definition" "task_definition" {
    family                   = "ecs-app-task"
    execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
    task_role_arn            = aws_iam_role.task_role.arn
    network_mode             = "awsvpc"
    requires_compatibilities = ["FARGATE"]
    cpu                      = var.fargate_cpu
    memory                   = var.fargate_memory
    container_definitions    = templatefile("${path.module}/templates/ecs/app.json.tpl",
        {
            name           = var.name
            app_image      = var.app_image
            app_port       = var.app_port
            fargate_cpu    = var.fargate_cpu
            fargate_memory = var.fargate_memory
            region     = var.region
        }
    )
}

resource "aws_ecs_service" "service" {
    name            = "ecs-app-service"
    cluster         = aws_ecs_cluster.main.id
    task_definition = aws_ecs_task_definition.task_definition.arn
    desired_count   = var.app_count
    launch_type     = "FARGATE"

    network_configuration {
        security_groups  = [aws_security_group.ecs.id]
        subnets          = [aws_subnet.my_public_subnet_1.id, aws_subnet.my_public_subnet_2.id]
        assign_public_ip = true
    }
}