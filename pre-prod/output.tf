output "elb_dns_name" {
  value = aws_lb.odoo.dns_name
}

output "odoo_url" {
  description = "Odoo URL"
  value       = aws_route53_record.ssxodoo.name
}