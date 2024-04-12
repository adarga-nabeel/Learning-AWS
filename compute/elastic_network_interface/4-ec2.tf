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

  tags = {
    Name = "ENI instance"
  }
}