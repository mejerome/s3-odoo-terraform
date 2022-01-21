resource "aws_ecr_repository" "odoo-app" {
  name = "odoo-app"
}

resource "aws_ecr_repository" "odoo-db" {
  name = "odoo-db"
}