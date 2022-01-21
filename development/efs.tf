resource "aws_efs_file_system" "odoodbefs" {
  tags = {
    Name = "odoodbefs"
  }
}

locals {
  subnets = [aws_subnet.web-subnet-1.id, aws_subnet.web-subnet-2.id]
}

resource "aws_efs_mount_target" "odoodbefs-mnt" {
  count = "2"

  file_system_id = aws_efs_file_system.odoodbefs.id
  subnet_id      = element(local.subnets, count.index)

  security_groups = [aws_security_group.odoo_sg.id, aws_security_group.https_sg.id]
}