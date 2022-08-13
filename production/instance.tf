
resource "aws_instance" "odoo-app" {
  ami                  = var.odoo_ami
  instance_type        = "t3.small"
  key_name             = var.key_name
  iam_instance_profile = "ec2_s3_access"


  network_interface {
    network_interface_id = aws_network_interface.odoo_nic.id
    device_index         = 0
  }

  monitoring = true

  user_data = <<EOF
      #!/bin/bash 
      sudo yum -y update 
      sudo amazon-linux-extras enable ansible2
      sudo yum install -y git ansible python3-pip
      sudo amazon-linux-extras install docker
      sudo service docker start
      sudo chkconfig docker on
      sudo usermod -a -G docker ec2-user

      echo "export RDS_HOST=${aws_db_instance.odoo-db.address}" >> /home/ec2-user/.bashrc
      echo "export RDS_USER=${aws_db_instance.odoo-db.username}" >> /home/ec2-user/.bashrc
      echo "export RDS_PASSWORD=${aws_db_instance.odoo-db.password}" >> /home/ec2-user/.bashrc
      echo "export RDS_NAME=${aws_db_instance.odoo-db.identifier}" >> /home/ec2-user/.bashrc
      sudo pip3 install docker-compose
      git clone --branch odoo-docker https://github.com/mejerome/s3-odoo-terraform.git /home/ec2-user/s3-odoo-terraform
      sudo chown -R ec2-user ~/s3-odoo-terraform
  EOF

  root_block_device {
    volume_type           = "standard"
    volume_size           = var.root_volume_size
    encrypted             = true
    delete_on_termination = true
  }

  depends_on = [
    aws_db_instance.odoo-db,
  ]
  tags = {
    "Name" = var.tag_name
  }
}