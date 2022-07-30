output "instance_dns_name" {
  value = aws_instance.ssxodoo.public_dns
}

output "public_ip" {
  value = aws_instance.ssxodoo.public_ip
}

output "db_address" {
  value = data.aws_db_instance.odoo-db.address
}

output "odoo_docker_lb_dns_name" {
  value = aws_lb.odoo-docker-lb.dns_name
}
