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

# When specifying network interfaces, you must include a device at index 0.

resource "aws_instance" "main" {
  ami           = "ami-0d7a109bf30624c99" # AMI in US East (Virginia) region
  instance_type = "t2.micro"

  # Attach Elastic Interface
  network_interface {
    network_interface_id = aws_network_interface.main.id
    device_index         = 0
  }

  network_interface {
    network_interface_id = aws_network_interface.two.id
    device_index         = 1
  }
}