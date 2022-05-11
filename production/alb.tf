resource "aws_lb" "odoo-lb" {
  name               = "ssx-odoo-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = module.vpc.public_subnets
  security_groups    = [aws_security_group.odoo-https.id, aws_security_group.odoo-http.id]

  enable_deletion_protection = false

  tags = {
    Name = var.tag_name
  }
}

resource "aws_lb_listener" "front_end" {
  load_balancer_arn = aws_lb.odoo-lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.ssxfinance.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.odoo-tg.arn
  }

  depends_on = [
    aws_acm_certificate.ssxfinance,
  ]
}

resource "aws_lb_listener" "redirect" {
  load_balancer_arn = aws_lb.odoo-lb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  depends_on = [
    aws_acm_certificate.ssxfinance,
  ]
}
resource "aws_lb_target_group" "odoo-tg" {
  name        = "ssx-odoo-lb-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "instance"
}

resource "aws_lb_target_group_attachment" "odoo-tg-attachment" {
  target_group_arn = aws_lb_target_group.odoo-tg.arn
  target_id        = aws_instance.odoo-app.id
  port             = 80
}