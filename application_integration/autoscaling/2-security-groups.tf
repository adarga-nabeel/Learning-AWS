resource "aws_security_group" "instance_sg" {
  name   = "ec2-sg"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group" "loadbalancer_sg" {
  name   = "alb-sg"
  vpc_id = module.vpc.vpc_id
}

resource "aws_security_group_rule" "instance_http" {
  type                     = "ingress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.instance_sg.id
  source_security_group_id = aws_security_group.loadbalancer_sg.id
}


resource "aws_security_group_rule" "instance_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.instance_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}


# resource "aws_security_group_rule" "ec2_full_egress" {
#   type              = "egress"
#   from_port         = 0
#   to_port           = 0
#   protocol          = "-1"
#   security_group_id = aws_security_group.instance_sg.id
#   cidr_blocks       = ["0.0.0.0/0"]
# }


resource "aws_security_group_rule" "alb_http" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.loadbalancer_sg.id
  cidr_blocks       = ["0.0.0.0/0"]
}


resource "aws_security_group_rule" "alb_http_egress" {
  type                     = "egress"
  from_port                = 80
  to_port                  = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.loadbalancer_sg.id
  source_security_group_id = aws_security_group.instance_sg.id
}
