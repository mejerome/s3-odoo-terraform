resource "aws_lb" "odoo_nw_load_balancer" {
  name               = "odoo-nw-load-balancer"
  internal           = true
  load_balancer_type = "network"
  subnets            = [aws_subnet.web-subnet-1.id, aws_subnet.web-subnet-2.id]

  tags = {
    Name = "odoo-nw-load-balancer"
  }

}
resource "aws_lb_target_group" "odoo_db_target_group" {
  name        = "odoo-db-target-group"
  port        = "5432"
  protocol    = "TCP"
  vpc_id      = aws_vpc.ssx-vpc.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    unhealthy_threshold = "3"
    interval            = "10"
    port                = "traffic-port"
    protocol            = "TCP"
  }

  tags = {
    Name = "odoo-db-target-group"
  }
}

resource "aws_lb_listener" "odoo_nw_listener" {
  load_balancer_arn = aws_lb.odoo_nw_load_balancer.arn
  port              = "5432"
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.odoo_db_target_group.arn
    type             = "forward"
  }
}

resource "aws_alb" "odoo_alb_load_balancer" {
  name            = "odoo-alb-load-balancer"
  security_groups = [aws_security_group.odoo_sg.id]
  subnets         = [aws_subnet.web-subnet-1.id, aws_subnet.web-subnet-2.id]

  tags = {
    Name = "odoo-alb-load-balancer"
  }
}

resource "aws_alb_target_group" "odoo_app_target_group" {
  name                 = "odoo-app-target-group"
  port                 = 80
  protocol             = "HTTP"
  vpc_id               = aws_vpc.ssx-vpc.id
  deregistration_delay = "10"

  health_check {
    healthy_threshold   = "2"
    unhealthy_threshold = "6"
    interval            = "30"
    matcher             = "200,301,302"
    path                = "/"
    protocol            = "HTTP"
    timeout             = "5"
  }

  stickiness {
    type = "lb_cookie"
  }

  tags = {
    Name = "odoo-app-target-group"
  }
}

resource "aws_alb_listener" "alb-listener" {
  load_balancer_arn = aws_alb.odoo_alb_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    target_group_arn = aws_alb_target_group.odoo_app_target_group.arn
    type             = "forward"
  }
}

resource "aws_autoscaling_attachment" "asg_attachment_odoo_app" {
  autoscaling_group_name = "odoo-autoscaling-group"
  alb_target_group_arn   = aws_alb_target_group.odoo_app_target_group.arn
  depends_on             = [aws_autoscaling_group.odoo-autoscaling-group]
}