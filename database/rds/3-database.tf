# resource "aws_db_instance" "example" {
#   engine                 = "mysql"
#   db_name                = "${var.name}"
#   identifier             = "${var.name}"
#   instance_class         = "db.m5d.large"
#   allocated_storage      = 100
#   publicly_accessible    = true
#   username               = var.db-username
#   password               = var.db-password
#   vpc_security_group_ids = [aws_security_group.allow_db.id]
#   skip_final_snapshot    = true

#   tags = {
#     Name = "database-${var.name}"
#   }
# }


resource "aws_db_subnet_group" "my_db_subnet_group" {
  name = "my-db-subnet-group"
  subnet_ids = [aws_subnet.public_subnet_1.id, aws_subnet.public_subnet_2.id]

  tags = {
    Name = "My DB Subnet Group"
  }
}


resource "aws_db_instance" "default" {
  allocated_storage = 100
  storage_type = "gp2"
  engine = "mysql"
  engine_version = "5.7"
  instance_class = "db.m5d.large"
  identifier = "mydb"
  username = var.db-username
  password = var.db-password

  vpc_security_group_ids = [aws_security_group.allow_db.id]
  db_subnet_group_name = aws_db_subnet_group.my_db_subnet_group.name

  skip_final_snapshot = true

  tags = {
    Name = "database-${var.name}"
  }
}