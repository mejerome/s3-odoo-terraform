output "instance_dns_name" {
  value = aws_instance.ssxodoo.public_dns
}

output "public_ip" {
  value = aws_instance.ssxodoo.public_ip
}

output "db_address" {
  value = data.aws_db_instance.odoo-db.address
}
