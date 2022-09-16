resource "aws_acm_certificate" "syslog" {
  domain_name       = aws_route53_record.syslog-demo.name
  validation_method = "DNS"
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "us_ssxfinance" {
  domain_name       = "us-finance.internal.secondstax.com"
  validation_method = "EMAIL"
}

resource "aws_acm_certificate" "ssxfinance" {
  domain_name       = "finance.internal.secondstax.com"
  validation_method = "EMAIL"
}

resource "aws_route53_record" "cert_validation_record_syslog" {
  zone_id = var.hosted_zone_id
  for_each = {
    for dvo in aws_acm_certificate.syslog.domain_validation_options : dvo.domain_name => {
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
}

resource "aws_acm_certificate_validation" "syslog" {
  certificate_arn         = aws_acm_certificate.syslog.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation_record_syslog : record.fqdn]

  lifecycle {
    create_before_destroy = true
  }
}
