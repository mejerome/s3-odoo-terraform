resource "aws_db_parameter_group" "odoo" {
  name   = "odoo"
  family = "postgres13"

  parameter {
    name  = "log_connections"
    value = "1"
  }
}

resource "aws_db_instance" "odoo-db" {
  identifier             = "odoodatabase"
  instance_class         = "db.t3.small"
  allocated_storage      = 60
  engine                 = "postgres"
  engine_version         = "13.4"
  username               = var.db_username
  password               = var.db_password
  db_subnet_group_name   = aws_db_subnet_group.odoo-db.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  parameter_group_name   = aws_db_parameter_group.odoo.name
  publicly_accessible    = false
  skip_final_snapshot    = true
  multi_az               = true
  deletion_protection    = true
  tags = {
    "Name" = var.tag_name
  }
}
