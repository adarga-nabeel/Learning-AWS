resource "aws_db_instance" "example" {
  engine                 = "mysql"
  db_name                = "${var.name}"
  identifier             = "${var.name}"
  instance_class         = "db.m5d.large"
  allocated_storage      = 100
  publicly_accessible    = true
  username               = var.db-username
  password               = var.db-password
  vpc_security_group_ids = [aws_security_group.allow_db.id]
  skip_final_snapshot    = true

  tags = {
    Name = "database-${var.name}"
  }
}