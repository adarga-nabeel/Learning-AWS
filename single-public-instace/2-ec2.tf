# Create two Public virtial machines (instances)

resource "aws_instance" "Public_instance_1" {
  ami           = "ami-03c07bedab170b21a" # AMI in London region
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_public_subnet_1.id

  tags = {
    Name = "PublicInstance1"
  }
}
