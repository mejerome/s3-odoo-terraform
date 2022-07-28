# output "rds_hostname" {
#   description = "RDS instance hostname"
#   value       = data.aws_db_instance.odoo-db.address
# }

# output "rds_port" {
#   description = "RDS instance port"
#   value       = data.aws_db_instance.odoo-db.port
# }

# output "rds_username" {
#   description = "RDS instance root username"
#   value       = data.aws_db_instance.odoo-db.username
# }

# output "odoo_instance_dns" {
#   description = "Odoo instance DNS"
#   value       = aws_instance.odoo-app.public_dns
# }

# output "odoo_url" {
#   description = "Odoo instance URL"
#   value       = aws_route53_record.ssxodoo.name
# }

# output "lb_url" {
#   description = "Odoo load balancer URL"
#   value       = aws_lb.odoo-lb.dns_name
# }