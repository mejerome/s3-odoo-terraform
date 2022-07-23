resource "aws_lb" "odoo-lb" {
  name               = "odoo-dev-lb"
  internal           = false
  load_balancer_type = "application"
  subnets            = data.aws_subnets.ssx_public_subnets.ids
  security_groups    = [aws_security_group.alb_sg.id]

  tags = {
    Name = "odoo-dev"
  }
}

resource "aws_lb_target_group" "target-group" {
  name     = "odoo-app"
  port     = 80
  protocol = "HTTP"
  target_type = "ip"
  vpc_id   = data.aws_vpc.ssx-prod.id
  health_check {
    path                = "/"
    interval            = "10"
    port                = "80"
    protocol            = "HTTP"
    timeout             = "5"
    healthy_threshold   = "2"
    unhealthy_threshold = "2"
    matcher             = "200-299"
  }
  tags = {
    Name = "odoo-dev"
  }
}

resource "aws_lb_listener" "listener" {
  load_balancer_arn = aws_lb.odoo-lb.arn
  port              = 80
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.target-group.arn
  }
}
