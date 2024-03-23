# Create two public virtial machines (instances)

resource "aws_instance" "public_instance_1" {
  # Create a counter based on the number of AZ on the region
  count                  = length(data.aws_availability_zones.available.names)
  ami                    = "ami-0d7a109bf30624c99" # AMI in US East (Virginia) region
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.subnet.*.id[count.index]
  vpc_security_group_ids = [aws_security_group.allow_tls.id]

  # Attach an AWS generated dynamic public IP to the instance
  associate_public_ip_address = true

  user_data = templatefile("${path.module}/bootstrap.tftpl",
    { efs_id      = aws_efs_file_system.main.id,
      server_name = data.aws_availability_zones.available.names[count.index]
    }
  )

  # Restart instance to ensure user data is updated
  user_data_replace_on_change = true

  tags = {
    Name = data.aws_availability_zones.available.names[count.index]
  }
}
