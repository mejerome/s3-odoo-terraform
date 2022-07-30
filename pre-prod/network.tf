data "aws_vpc" "ssx-prod" {
  filter {
    name   = "tag:Name"
    values = ["ssx-prod"]
  }
}

data "aws_subnet_ids" "ssx_public_subnets" {
  vpc_id = data.aws_vpc.ssx-prod.id
  filter {
    name   = "tag:Name"
    values = ["ssx-prod-public-*"]
  }
}

resource "random_id" "index" {
  byte_length = 2
}

locals {
  subnet_ids_list = tolist(data.aws_subnet_ids.ssx_public_subnets.ids)

  subnet_ids_random_index = random_id.index.dec % length(data.aws_subnet_ids.ssx_public_subnets.ids)

  instance_subnet_id = local.subnet_ids_list[local.subnet_ids_random_index]
}

resource "aws_network_interface" "odoo_nic" {
  subnet_id = local.instance_subnet_id
  security_groups = [
    aws_security_group.allow_odoo.id,
    aws_security_group.allow_ssh.id,
  ]
  tags = {
    Name = var.tag_name
  }
}