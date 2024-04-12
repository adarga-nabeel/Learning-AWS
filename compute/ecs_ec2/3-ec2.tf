# Step 1: Create an EC2 launch template
resource "aws_iam_role" "ecsInstanceRole" {
    name = "ecsInstanceRole"
    assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF
}

resource "aws_iam_role_policy_attachment" "ecsInstanceRole" {
    role = "${aws_iam_role.ecsInstanceRole.name}"
    policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

# After defining the IAM role and attaching policies, you need to create an IAM instance profile and associate it with the IAM role you created
resource "aws_iam_instance_profile" "ecs_instance_profile" {
  name = "ecsInstanceProfile"  # This name can be the same or different from the IAM role name
  role = aws_iam_role.ecsInstanceRole.name
}

resource "aws_launch_template" "main" {
 name_prefix   = "ecs-template"
 image_id      = "ami-0d7a109bf30624c99" # AMI in US East (Virginia) region
 instance_type = "t2.small"

 vpc_security_group_ids = [aws_security_group.allow_tls.id]
 iam_instance_profile {
   name = aws_iam_instance_profile.ecs_instance_profile.name
 }

 block_device_mappings {
   device_name = "/dev/xvda"
   ebs {
     volume_size = 30
     volume_type = "gp3"
   }
 }

 tag_specifications {
   resource_type = "instance"
   tags = {
     Name = "${var.name}-ecs-instance"
   }
 }

 user_data = filebase64("${path.module}/templates/userdata.sh")
}

# Step 2: Create an auto-scaling group (ASG)
resource "aws_autoscaling_group" "ecs_asg" {
 vpc_zone_identifier = [aws_subnet.my_public_subnet_1.id, aws_subnet.my_public_subnet_2.id]
 desired_capacity    = 2
 max_size            = 3
 min_size            = 1

 launch_template {
   id      = aws_launch_template.main.id
   version = "$Latest"
 }

 tag {
   key                 = "AmazonECSManaged"
   value               = true
   propagate_at_launch = true
 }
}

# Step 3: Configure Application Load Balancer (ALB)
resource "aws_lb" "main" {
 name               = "ecs-alb"
 internal           = false
 load_balancer_type = "application"
 security_groups    = [aws_security_group.allow_tls.id]
 subnets            = [aws_subnet.my_public_subnet_1.id, aws_subnet.my_public_subnet_2.id]

 tags = {
   Name = "${var.name}-ecs-alb"
 }
}

resource "aws_lb_listener" "main" {
 load_balancer_arn = aws_lb.main.arn
 port              = 80
 protocol          = "HTTP"

 default_action {
   type             = "forward"
   target_group_arn = aws_lb_target_group.ecs_tg.arn
 }
}

resource "aws_lb_target_group" "ecs_tg" {
 name        = "ecs-target-group"
 port        = 80
 protocol    = "HTTP"
 target_type = "ip"
 vpc_id      = aws_vpc.main.id

 health_check {
   path = "/"
 }
}