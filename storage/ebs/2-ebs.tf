resource "aws_ebs_volume" "main" {
  availability_zone = "us-east-1a"
  size              = 10 # Gi
  type              = "gp3"


  tags = {
    Name = "main_ebs_volume"
  }
}

resource "aws_volume_attachment" "main" {
  device_name = "/dev/sdh"
  volume_id   = aws_ebs_volume.main.id
  instance_id = aws_instance.main.id
}
