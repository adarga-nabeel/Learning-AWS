# Traffic to the ECS cluster should only come from the ALB
resource "aws_security_group" "ecs" {
    name        = "ecs-security-group"
    description = "allow inbound access from the ALB only"
    vpc_id      = aws_vpc.main.id

    ingress {
        protocol        = "tcp"
        from_port       = var.app_port
        to_port         = var.app_port
        cidr_blocks = ["0.0.0.0/0"]
    }

    egress {
        protocol    = "-1"
        from_port   = 0
        to_port     = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
}