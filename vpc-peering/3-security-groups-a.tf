# Create the Security Group Block

resource "aws_security_group" "allow_tls_a" {
  name        = "allow_tls_a"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = aws_vpc.my_vpc_a.id

  tags = {
    Name = "allow_tls_a"
  }
}

# Create the security group block INGRESS Rules

## Please note, for added security, ensure you only specify the necessary cidr_ipv4 block

resource "aws_vpc_security_group_ingress_rule" "allow_http_a" {
  security_group_id = aws_security_group.allow_tls_a.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 80
  ip_protocol       = "tcp"
  to_port           = 80
}

resource "aws_vpc_security_group_ingress_rule" "allow_https_a" {
  security_group_id = aws_security_group.allow_tls_a.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 443
  ip_protocol       = "tcp"
  to_port           = 443
}

resource "aws_vpc_security_group_ingress_rule" "allow_ssh_a" {
  security_group_id = aws_security_group.allow_tls_a.id
  cidr_ipv4         = "0.0.0.0/0"
  from_port         = 22
  ip_protocol       = "tcp"
  to_port           = 22
}

# Create the security group block EGRESS Rules

resource "aws_vpc_security_group_egress_rule" "allow_all_traffic_ipv4_a" {
  security_group_id = aws_security_group.allow_tls_a.id
  cidr_ipv4         = "0.0.0.0/0"
  ip_protocol       = "-1" # semantically equivalent to all ports
}