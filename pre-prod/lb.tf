resource "aws_lb" "odoo-docker-lb" {
  name               = "odoo-docker-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = data.aws_subnet_ids.ssx_public_subnets.ids
  security_groups = [
    aws_security_group.allow_http.id,
    aws_security_group.allow_https.id,
    aws_security_group.allow_ssh.id,
  ]

  enable_deletion_protection = false

  tags = {
    Name = var.tag_name
  }
}

resource "aws_lb_listener" "pre-prod" {
  load_balancer_arn = aws_lb.odoo-docker-lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.pre-prod.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.odoo-docker-tg.arn
  }

  depends_on = [
    aws_instance.ssxodoo,
    aws_acm_certificate.pre-prod,
  ]
}

resource "aws_lb_target_group" "odoo-docker-tg" {
  name        = "odoo-docker-lb-tg"
  port        = 8069
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.ssx-prod.id
  target_type = "instance"
}

resource "aws_lb_target_group_attachment" "odoo-docker-tg-attachment" {
  target_group_arn = aws_lb_target_group.odoo-docker-tg.arn
  target_id        = aws_instance.ssxodoo.id
  port             = 8069
}

resource "aws_lb_listener" "syslog" {
  load_balancer_arn = aws_lb.odoo-docker-lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.syslog.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.syslog-docker-tg.arn
  }

  depends_on = [
    aws_instance.ssxodoo,
    # aws_acm_certificate.syslog,
  ]
}

resource "aws_lb_target_group" "syslog-docker-tg" {
  name        = "syslog-docker-lb-tg"
  port        = 8068
  protocol    = "HTTP"
  vpc_id      = data.aws_vpc.ssx-prod.id
  target_type = "instance"
}

resource "aws_lb_target_group_attachment" "syslog-docker-tg-attachment" {
  target_group_arn = aws_lb_target_group.syslog-docker-tg.arn
  target_id        = aws_instance.ssxodoo.id
  port             = 8068
}