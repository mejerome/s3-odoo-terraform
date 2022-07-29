output "instance_dns_name" {
  value = aws_instance.ssxodoo.public_dns
}

output "public_ip" {
  value = aws_instance.ssxodoo.public_ip
}