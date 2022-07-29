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
      ansible-galaxy install geerlingguy.docker geerlingguy.pip

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

  provisioner "remote-exec" {
    inline = [
      "sleep 5m",
      "git clone --branch odoo-docker https://github.com/mejerome/s3-odoo-terraform.git" ,
      "ansible-playbook -c local -i 127.0.0.1, s3-odoo-terraform/playbook/install_docker.yml",
    ]
  }

  connection {
    type        = "ssh"
    user        = "ec2-user"
    private_key = file(var.key_file)
    host        = self.public_ip
  }
  tags = {
    "Name" = var.tag_name
  }
}