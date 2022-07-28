resource "aws_acm_certificate" "ssx" {
  domain_name       = aws_route53_record.ssxodoo.name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_route53_record" "ssxodoo" {
  zone_id = var.hosted_zone_id
  name    = var.hosted_zone_name
  type    = "CNAME"
  ttl     = "300"

  records = [
    aws_lb.odoo-lb.dns_name,
  ]

  depends_on = [
    aws_lb.odoo-lb,
  ]
}

resource "aws_route53_record" "cert_validation_record" {
  for_each = {
    for dvo in aws_acm_certificate.ssx.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = var.hosted_zone_id
}

resource "aws_acm_certificate_validation" "ssx" {
  certificate_arn         = aws_acm_certificate.ssx.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation_record : record.fqdn]

  lifecycle {
    create_before_destroy = true
  }
}
