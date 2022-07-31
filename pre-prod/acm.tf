resource "aws_acm_certificate" "pre-prod" {
  domain_name       = aws_route53_record.pre-prod.name
  validation_method = "DNS"
  # subject_alternative_names = ["finance.internal.secondstax.com"]
  lifecycle {
    create_before_destroy = true
  }
}

# resource "aws_acm_certificate" "ssxfinance" {
#   domain_name       = "finance.internal.secondstax.com"
#   validation_method = "EMAIL"
# }

resource "aws_route53_record" "pre-prod" {
  zone_id = var.hosted_zone_id
  name    = var.hosted_zone_name
  type    = "CNAME"
  ttl     = "300"

  records = [
    aws_lb.odoo-docker-lb.dns_name,
  ]

  depends_on = [
    aws_lb.odoo-docker-lb,
  ]
}

resource "aws_route53_record" "pre-prod-validation" {
  for_each = {
    for dvo in aws_acm_certificate.pre-prod.domain_validation_options : dvo.domain_name => {
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

resource "aws_acm_certificate_validation" "pre-prod" {
  certificate_arn         = aws_acm_certificate.pre-prod.arn
  validation_record_fqdns = [for record in aws_route53_record.pre-prod-validation : record.fqdn]

  lifecycle {
    create_before_destroy = true
  }
}