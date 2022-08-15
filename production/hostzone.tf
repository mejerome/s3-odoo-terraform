# resource "aws_route53_record" "syslog" {
#   zone_id = var.hosted_zone_id
#   name    = "website.sysloggh.com"
#   type    = "CNAME"
#   ttl     = "300"

#   records = [
#     aws_instance.odoo-app.public_dns,
#   ]

#   depends_on = [
#     aws_instance.odoo-app,
#   ]
# }

resource "aws_route53_record" "ssxodoo" {
  zone_id = var.hosted_zone_id
  name    = var.hosted_zone_name
  type    = "CNAME"
  ttl     = "300"

  records = [
    aws_lb.ssxghana_lb.dns_name,
  ]

  depends_on = [
    aws_lb.ssxghana_lb,
  ]
}

