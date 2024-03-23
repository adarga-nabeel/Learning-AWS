resource "aws_security_group" "efs" {
  name        = "allow_ec2_ef"
  description = "Allow EC2 inbound access to EFS"
  vpc_id      = aws_vpc.vpc.id

  tags = {
    Name = "allow_ec2_efs"
  }
}

resource "aws_vpc_security_group_ingress_rule" "allow_ec2_inbound" {
  security_group_id            = aws_security_group.efs.id
  referenced_security_group_id = aws_security_group.allow_tls.id
  #   from_port                    = 0
  #   ip_protocol                  = "tcp"
  #   to_port                      = 0
  ip_protocol = "-1"
}

resource "aws_vpc_security_group_egress_rule" "allow_all_efs_egress" {
  security_group_id = aws_security_group.efs.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}