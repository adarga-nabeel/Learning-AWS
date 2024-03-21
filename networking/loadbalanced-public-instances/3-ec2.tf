# Create two public virtial machines (instances)

resource "aws_instance" "public_instance_1" {
  ami                    = "ami-03c07bedab170b21a" # AMI in London region
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.my_public_subnet_1.id
  vpc_security_group_ids = [aws_security_group.allow_tls.id]

  user_data = templatefile("${path.module}/userdata.tftpl",
  { server_name = "server 1" })

  # Restart instance to ensure user data is updated
  user_data_replace_on_change = true

  tags = {
    Name = "PublicInstance1"
  }
}

resource "aws_instance" "public_instance_2" {
  ami                    = "ami-03c07bedab170b21a" # AMI in London region
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.my_public_subnet_2.id
  vpc_security_group_ids = [aws_security_group.allow_tls.id]

  user_data = templatefile("${path.module}/userdata.tftpl",
  { server_name = "server 2" })

  # Restart instance to ensure user data is updated
  user_data_replace_on_change = true

  tags = {
    Name = "PublicInstance2"
  }
}