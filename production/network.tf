data "aws_availability_zones" "available" {}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "2.77.0"

  name                 = var.tag_name
  cidr                 = "10.0.0.0/16"
  azs                  = data.aws_availability_zones.available.names
  database_subnets     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  private_subnets      = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
  public_subnets       = ["10.0.7.0/24", "10.0.8.0/24", "10.0.9.0/24"]
  enable_dns_hostnames = true
  enable_dns_support   = true
}

resource "aws_db_subnet_group" "odoo-db" {
  name       = "db subnet group"
  subnet_ids = module.vpc.database_subnets

  tags = {
    Name = var.tag_name
  }
}

resource "aws_network_interface" "odoo_nic" {
  subnet_id = module.vpc.public_subnets[0]
  security_groups = [
    aws_security_group.allow-ssxodoo.id,
    aws_security_group.allow-uscorp.id,
    aws_security_group.ssh.id,

  ]
  tags = {
    Name = var.tag_name
  }
}