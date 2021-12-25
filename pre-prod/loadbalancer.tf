
# resource "aws_elb" "odoo" {
#   name = "web-elb"
#   security_groups = [
#     aws_security_group.allow_elb.id,
#   ]
#   count = 3
#   subnets                   = aws_subnet.public.*.id
#   availability_zones = data.aws_availability_zones.available.names
#   cross_zone_load_balancing = true

#   health_check {
#     healthy_threshold   = 2
#     unhealthy_threshold = 2
#     timeout             = 3
#     interval            = 30
#     target              = "HTTP:80/"
#   }

#   listener {
#     lb_port           = 80
#     lb_protocol       = "http"
#     instance_port     = "80"
#     instance_protocol = "http"
#   }

#   tags = {
#     Name = var.tag_name
#   }
# }

resource "aws_lb" "odoo" {
  name               = "odoo-lb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_elb.id]
  subnets            = aws_subnet.public.*.id
}
resource "aws_lb_listener" "odoo_listener" {
  load_balancer_arn = aws_lb.odoo.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.odoo_target_group.arn
  }
}

resource "aws_lb_target_group" "odoo_target_group" {
  name     = "app-target-group"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.vpc.id

  health_check {
    port     = 80
    protocol = "HTTP"
  }
}

resource "aws_route53_record" "ssxodoo" {
  zone_id = var.hosted_zone_id
  name    = "preprod.sysloggh.com"
  type    = "CNAME"
  ttl     = "300"

  records = [
    aws_lb.odoo.dns_name,
  ]

  depends_on = [
    aws_lb.odoo,
  ]
}