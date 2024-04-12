resource "aws_network_interface" "main" {
  subnet_id   = aws_subnet.public_subnet_us_east_1a.id
  security_groups = [aws_security_group.allow_tls.id]

  tags = {
    Name = "ENI with EIP"
  }
}

resource "aws_eip" "one" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.main.id

  tags = {
    Name = "EIP one"
  }
}

resource "aws_eip" "two" {
  domain                    = "vpc"
  network_interface         = aws_network_interface.main.id

  tags = {
    Name = "EIP two"
  }
}

resource "aws_network_interface" "two" {
  subnet_id   = aws_subnet.public_subnet_us_east_1a.id
  security_groups = [aws_security_group.allow_tls.id]

  tags = {
    Name = "ENI without EIP"
  }
}
