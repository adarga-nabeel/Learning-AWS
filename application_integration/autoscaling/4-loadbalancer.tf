resource "aws_lb" "loadbalancer" {
  name               = "${var.name}-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.loadbalancer_sg.id]
  subnets            = module.vpc.public_subnets
}


resource "aws_lb_listener" "loadbalancer_listener" {
  load_balancer_arn = aws_lb.loadbalancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.loadbalancer_target_group.arn
  }
}


resource "aws_lb_target_group" "loadbalancer_target_group" {
  name     = "${var.name}-lb-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = module.vpc.vpc_id
}


resource "aws_autoscaling_attachment" "loadbalancer_autoscaler_attachment" {
  autoscaling_group_name = aws_autoscaling_group.auto_scaling.id
  lb_target_group_arn    = aws_lb_target_group.loadbalancer_target_group.arn
}