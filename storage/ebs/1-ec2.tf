resource "aws_instance" "main" {
  ami               = "ami-0d7a109bf30624c99" # AMI in US East (Virginia) region
  availability_zone = "us-east-1a"
  instance_type     = "t2.micro"

  tags = {
    Name = "EBS attached Instance"
  }

  user_data = templatefile("${path.module}/bootstrap.tftpl",
  { server_name = "server 1" })

  # Restart instance to ensure user data is updated
  user_data_replace_on_change = true
}