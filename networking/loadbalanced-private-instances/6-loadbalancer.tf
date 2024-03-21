# This is an Application Load Balancer


# MAIN LOAD BALANCER

resource "aws_lb" "main" {
  name               = "my-application-loadbalancer"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_tls_lb.id]
  subnets = [
    aws_subnet.my_public_lb_subnet_1.id,
    aws_subnet.my_public_lb_subnet_2.id
  ]

  enable_deletion_protection = false

  tags = {
    Name        = "ALB"
    Environment = "DEVELOPMENT"
  }
}

# TARGET GROUP

resource "aws_lb_target_group" "main" {
  name        = "loadbalancer-target-group"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = aws_vpc.my_vpc.id

  load_balancing_algorithm_type = "round_robin"
}


# LISTENERS

resource "aws_lb_listener" "main" {
  load_balancer_arn = aws_lb.main.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

# ATTACHMENTS

resource "aws_lb_target_group_attachment" "instance-1" {
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = aws_instance.public_instance_1.id
  port             = 80
}

resource "aws_lb_target_group_attachment" "instance-2" {
  target_group_arn = aws_lb_target_group.main.arn
  target_id        = aws_instance.public_instance_2.id
  port             = 80
}