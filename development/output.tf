# output "odoo_public_dns" {
#   description = "Odoo Public DNS"
#   value       = aws_instance.odoo.public_dns
# }

# output "odoo_public_ip" {
#   description = "Odoo Public IP"
#   value       = aws_instance.odoo.public_ip
# }

# output "odoo_url" {
#   description = "Odoo URL"
#   value       = aws_route53_record.ssxodoo.name
# }
output "region" {
  value = var.region
}

output "odoo_vpc_id" {
  value = aws_vpc.ssx-vpc.id
}

output "app-alb-load-balancer-name" {
  value = aws_alb.odoo_alb_load_balancer.name
}

output "app-alb-load-balancer-dns-name" {
  value = aws_alb.odoo_alb_load_balancer.dns_name
}

output "nw-lb-load-balancer-dns-name" {
  value = aws_lb.odoo_nw_load_balancer.dns_name
}

output "nw-lb-load-balancer-name" {
  value = aws_lb.odoo_nw_load_balancer.name
}

output "odoo-app-target-group-arn" {
  value = aws_alb_target_group.odoo_app_target_group.arn
}

output "odoo-db-target-group-arn" {
  value = aws_lb_target_group.odoo_db_target_group.arn
}

output "mount-target-dns" {
  description = "Address of the mount target provisioned"
  value       = aws_efs_mount_target.odoodbefs-mnt.0.dns_name
}