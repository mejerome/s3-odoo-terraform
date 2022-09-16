# resource "aws_route53_record" "ssxuscorp" {
#   zone_id = var.hosted_zone_id
#   name    = "ssxuscorp.sysloggh.com"
#   type    = "CNAME"
#   ttl     = "300"

#   records = [
#     aws_lb.ssxuscorp_lb.dns_name,
#   ]

#   depends_on = [
#     aws_lb.ssxuscorp_lb,
#   ]
# }

resource "aws_route53_record" "syslog-demo" {
  zone_id = var.hosted_zone_id
  name    = var.hosted_zone_name
  type    = "CNAME"
  ttl     = "300"

  records = [
    aws_lb.syslog_odoo_lb.dns_name,
  ]

  depends_on = [
    aws_lb.syslog_odoo_lb
  ]
}

