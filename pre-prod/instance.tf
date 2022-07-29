resource "aws_instance" "ssxodoo" {
  ami                  = var.image_id
  instance_type        = var.instance_type
  key_name             = var.key_name
  iam_instance_profile = "ec2_s3_access"

  user_data = <<EOF
      #!/bin/bash
      export RDS_HOST=${data.aws_db_instance.odoo-db.address}
      export RDS_USER=${data.aws_db_instance.odoo-db.master_username}
      export RDS_PASS=${var.db_password}
      export RDS_NAME=${data.aws_db_instance.odoo-db.db_name}
      sudo yum -y update 
      sudo amazon-linux-extras enable ansible2
      sudo yum install -y git ansible
      sudo amazon-linux-extras install docker
      sudo service docker start
      sudo chkconfig docker on
      sudo usermod -a -G docker ec2-user
  EOF

  root_block_device {
    volume_type           = "standard"
    volume_size           = var.root_volume_size
    encrypted             = true
    delete_on_termination = true
  }
  network_interface {
    network_interface_id = aws_network_interface.odoo_nic.id
    device_index         = 0
  }

  monitoring = true
  tags = {
    "Name" = var.tag_name
  }
}