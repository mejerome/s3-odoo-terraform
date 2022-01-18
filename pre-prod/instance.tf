
resource "aws_instance" "ssxodoo" {
  ami                  = var.image_id
  instance_type        = var.instance_type
  key_name             = var.key_name
  iam_instance_profile = "ec2_s3_access"
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
      "sudo apt-get update",
      "sudo apt-get install -y python3-pip git ansible",
      "git clone https://github.com/mejerome/s3-odoo-terraform.git",
      "ansible-playbook s3-odoo-terraform/playbook/bitnami_prep.yml",
    ]
  }
  # connection {
  #   type        = "ssh"
  #   user        = "bitnami"
  #   private_key = file(var.key_file)
  #   host        = self.public_ip
  # }
  # provisioner "local-exec" {
  #   command = "sleep 120; ANSIBLE_HOST_KEY_CHECKING=False ansible-playbook -u bitnami --private-key ${var.key_file} -i '${self.public_ip},' ../playbook/bitnami_prep.yml"
  # }
}