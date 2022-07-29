provider "aws" {
  profile = "default"
  region  = var.region
}

data "aws_db_instance" "odoo-db" {
  db_instance_identifier = "odoodatabase"
}
