resource "aws_launch_template" "launch_template" {
  name_prefix             = "learn-terraform-aws-asg-"
  image_id                = "ami-0bb84b8ffd87024d8"
  # instance_type           = "t3.small"
  user_data               = filebase64("${path.module}/user-data.sh")
  key_name                = "cloudguru"

  network_interfaces {
    security_groups              = [aws_security_group.instance_sg.id]
    associate_public_ip_address  = true
    device_index                 = 0  # Unique device index
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_autoscaling_group" "auto_scaling" {
  name                 = "${var.name}-auto-scaler"
  min_size             = 1
  max_size             = 3
  desired_capacity     = 1
  vpc_zone_identifier  = module.vpc.private_subnets

  mixed_instances_policy {
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.launch_template.id
      }
      override {
        instance_type = "t3.small"
      }
    }
  }

  target_group_arns = [aws_lb_target_group.loadbalancer_target_group.arn]

  health_check_type    = "EC2"

  tag {
    key                 = "Name"
    value               = "${var.name}-auto-scaler"
    propagate_at_launch = true
  }
}


resource "aws_autoscaling_policy" "autoscaling_policy" {
  name                   = "${var.name}-autoscaling_policy"
  policy_type            = "TargetTrackingScaling"
  autoscaling_group_name = aws_autoscaling_group.auto_scaling.name

  estimated_instance_warmup = 300

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }

    target_value = 70.0
  }
}