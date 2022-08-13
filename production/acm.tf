resource "aws_acm_certificate" "ssx" {
  domain_name       = aws_route53_record.ssxodoo.name
  validation_method = "DNS"
  # subject_alternative_names = ["finance.internal.secondstax.com"]
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate" "ssxfinance" {
  domain_name       = "finance.internal.secondstax.com"
  validation_method = "EMAIL"
}

resource "aws_route53_record" "cert_validation_record" {
  zone_id = var.hosted_zone_id
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
}

resource "aws_acm_certificate_validation" "ssx" {
  certificate_arn         = aws_acm_certificate.ssx.arn
  validation_record_fqdns = [for record in aws_route53_record.cert_validation_record : record.fqdn]

  lifecycle {
    create_before_destroy = true
  }
}

# resource "aws_acm_certificate_validation" "ssxfinance" {
#   certificate_arn         = aws_acm_certificate.ssxfinance.arn

#   lifecycle {
#     create_before_destroy = true
#   }
# }
