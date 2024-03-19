# Create a Public virtial machines (instances)

resource "aws_instance" "Public_instance_1_b" {
  ami                    = "ami-0d7a109bf30624c99" # AMI in US East (Virginia) region
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.my_public_subnet_1_b.id
  vpc_security_group_ids = [aws_security_group.allow_tls_b.id]

  user_data = templatefile("${path.module}/userdata.tftpl",
  { server_name = "server 2" })

  # Restart instance to ensure user data is updated
  user_data_replace_on_change = true

  tags = {
    Name = "PublicInstance2"
  }
}
