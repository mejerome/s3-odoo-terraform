resource "aws_route53_record" "ssxodoo" {
  zone_id = var.hosted_zone_id
  name    = var.hosted_zone_name
  type    = "CNAME"
  ttl     = "300"

  records = [
    aws_instance.ssxodoo.public_dns,
  ]

  depends_on = [
    aws_instance.ssxodoo,
  ]
}