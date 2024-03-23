# Provides an Elastic File System (EFS) File System resource.
resource "aws_efs_file_system" "main" {
  creation_token   = "personal-efs"
  performance_mode = "generalPurpose"
  throughput_mode  = "elastic"

  tags = {
    Name = "personal-efs"
  }
}


# Create mount targets on each AZ's associated subnet for servers running on the subnet
# to have access to the EFS data
resource "aws_efs_mount_target" "efs-mt" {
  count           = length(data.aws_availability_zones.available.names)
  file_system_id  = aws_efs_file_system.main.id
  subnet_id       = aws_subnet.subnet[count.index].id
  security_groups = [aws_security_group.efs.id]
}