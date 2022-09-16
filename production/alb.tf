resource "aws_lb_target_group" "ssx_ghana" {
  name        = "ssx-gh-lb-tg"
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

resource "aws_lb_target_group" "syslog_odoo" {
  name        = "syslog-odoo-lb-tg"
  port        = 8068
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "instance"
  health_check {
    path                = "/"
    interval            = 30
    port                = 8068
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

resource "aws_lb_target_group" "ssxuscorp" {
  name        = "ssxuscorp-lb-tg"
  port        = 8067
  protocol    = "HTTP"
  vpc_id      = module.vpc.vpc_id
  target_type = "instance"
  health_check {
    path                = "/"
    interval            = 30
    port                = 8067
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

resource "aws_lb_target_group_attachment" "ssx_ghana" {
  target_group_arn = aws_lb_target_group.ssx_ghana.arn
  target_id        = aws_instance.odoo-app.id
  port             = 8069
}

resource "aws_lb_target_group_attachment" "syslog_odoo" {
  target_group_arn = aws_lb_target_group.syslog_odoo.arn
  target_id        = aws_instance.odoo-app.id
  port             = 8068
}

resource "aws_lb_target_group_attachment" "ssxuscorp" {
  target_group_arn = aws_lb_target_group.ssxuscorp.arn
  target_id        = aws_instance.odoo-app.id
  port             = 8067
}

resource "aws_lb_listener" "ssx_ghana" {
  load_balancer_arn = aws_lb.ssxghana_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.ssxfinance.arn

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ssx_ghana.arn
  }
}

resource "aws_lb_listener" "syslog_odoo" {
  load_balancer_arn = aws_lb.syslog_odoo_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.syslog.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.syslog_odoo.arn
  }
}

resource "aws_lb_listener" "ssxuscorp" {
  load_balancer_arn = aws_lb.ssxuscorp_lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = aws_acm_certificate.us_ssxfinance.arn
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.ssxuscorp.arn
  }
  
}

resource "aws_lb_listener" "ssx_redirect" {
  load_balancer_arn = aws_lb.ssxghana_lb.arn
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
}

resource "aws_lb_listener" "syslog_redirect" {
  load_balancer_arn = aws_lb.syslog_odoo_lb.arn
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
}

resource "aws_lb_listener" "ssxuscorp_redirect" {
  load_balancer_arn = aws_lb.ssxuscorp_lb.arn
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
}

resource "aws_lb" "ssxghana_lb" {
  name               = "ssx-ghana-lb"
  internal           = false
  security_groups    = [aws_security_group.odoo-https.id, aws_security_group.odoo-http.id]
  subnets            = module.vpc.public_subnets
  load_balancer_type = "application"

  tags = {
    "Name" = var.tag_name
  }
}

resource "aws_lb" "syslog_odoo_lb" {
  name               = "syslog-odoo-lb"
  internal           = false
  security_groups    = [aws_security_group.odoo-https.id, aws_security_group.odoo-http.id]
  subnets            = module.vpc.public_subnets
  load_balancer_type = "application"

  tags = {
    "Name" = var.tag_name
  }
}

resource "aws_lb" "ssxuscorp_lb" {
  name               = "ssxuscorp-lb"
  internal           = false
  security_groups    = [aws_security_group.odoo-https.id, aws_security_group.odoo-http.id]
  subnets            = module.vpc.public_subnets
  load_balancer_type = "application"

  tags = {
    "Name" = var.tag_name
  }
  
}