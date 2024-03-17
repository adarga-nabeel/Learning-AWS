# Create two private virtial machines (instances)

resource "aws_instance" "private_instance_1" {
  ami           = "ami-03c07bedab170b21a" # AMI in London region
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_private_subnet_1.id

  tags = {
    Name = "PrivateInstance1"
  }
}

resource "aws_instance" "private_instance_2" {
  ami           = "ami-03c07bedab170b21a" # AMI in London region
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_private_subnet_2.id

  tags = {
    Name = "PrivateInstance2"
  }
}