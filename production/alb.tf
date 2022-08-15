resource "aws_lb_target_group" "ssxodoo" {
  name        = "ssx-odoo-lb-tg"
  port        = 8069
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "instance"
  health_check {
    path                = "/"
    interval            = 30
    port                = 8069
    protocol            = "HTTP"
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
    matcher             = "200-299"
  }

  tags = {
    "Name" = var.tag_name
  }
}

resource "aws_lb_target_group_attachment" "ssxodoo" {
  target_group_arn = aws_lb_target_group.ssxodoo.arn
  target_id        = aws_instance.odoo-app.id
  port             = 8069
}

resource "aws_lb_listener" "ssx_listener" {
  load_balancer_arn = aws_lb.ssxghana_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.ssx.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ssxodoo.arn
  }
}

resource "aws_lb" "ssxghana_lb" {
  name               = "ssx-lb"
  internal           = false
  security_groups    = [aws_security_group.odoo-https.id]
  subnets            = module.vpc.public_subnets
  load_balancer_type = "application"

  tags = {
    "Name" = var.tag_name
  }
}