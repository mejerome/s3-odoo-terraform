data "aws_ami" "ec2-ami" {
  filter {
    name   = "state"
    values = ["available"]
  }  
  filter {
    name   = "tag:Name"
    values = ["ssx-odoo-packer"]
  }
  owners = ["self"]
  most_recent = true
}
resource "aws_launch_configuration" "odoo" {
  name_prefix   = "odoo-"
  image_id      = data.aws_ami.ec2-ami.id
  instance_type = var.instance_type
  key_name      = var.key_name
  security_groups = [
    aws_security_group.allow_http.id,
    aws_security_group.allow_ssh.id,
  ]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "odoo" {
  name                 = var.tag_name
  launch_configuration = aws_launch_configuration.odoo.name
  min_size             = 1
  max_size             = 1
  desired_capacity     = 1
  target_group_arns    = [aws_lb_target_group.odoo_target_group.arn]

  enabled_metrics = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupTotalInstances"
  ]
  vpc_zone_identifier = aws_subnet.public.*.id
  metrics_granularity = "1Minute"
  lifecycle {
    create_before_destroy = true
  }
  tag {
    key                 = "Name"
    value               = "odoo"
    propagate_at_launch = true
  }
}