resource "aws_cloudwatch_log_group" "odoo_app" {
  name = "odoo_app"
}

resource "aws_cloudwatch_log_group" "odoo_db" {
  name = "odoo_db"
}