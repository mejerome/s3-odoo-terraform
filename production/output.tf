output "rds_hostname" {
  description = "RDS instance hostname"
  value       = aws_db_instance.odoo-db.address
}

output "rds_port" {
  description = "RDS instance port"
  value       = aws_db_instance.odoo-db.port
}

output "rds_username" {
  description = "RDS instance root username"
  value       = aws_db_instance.odoo-db.username
}

output "odoo_instance_dns" {
  description = "Odoo instance DNS"
  value       = aws_instance.odoo-app.public_dns
}

output "syslog_url" {
  description = "SSX URL"
  value       = aws_route53_record.syslog-demo.name
}

# output "ssxuscorp_url" {
#   description = "SSX URL"
#   value       = aws_route53_record.ssxuscorp.name
# }

output "ssx_loadbalancer_dns" {
  description = "SSX loadbalancer DNS"
  value       = aws_lb.ssxghana_lb.dns_name
}

output "syslog_loadbalancer_dns" {
  description = "Syslog loadbalancer DNS"
  value       = aws_lb.syslog_odoo_lb.dns_name
}