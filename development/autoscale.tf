resource "aws_launch_configuration" "ecs_launch_config" {
  image_id             = var.odoo_ami
  iam_instance_profile = aws_iam_instance_profile.ecs_agent.name
  security_groups      = [aws_security_group.ecs_sg.id]
  user_data            = "#!/bin/bash\necho ECS_CLUSTER=doo-dev >> /etc/ecs/ecs.config"
  instance_type        = "t2.micro"
  key_name             = aws_key_pair.ecs.key_name
  iam_instance_profile = aws_iam_instance_profile.ecs_agent.arn

}

resource "aws_autoscaling_group" "ecs_asg" {
  name                 = "asg"
  vpc_zone_identifier  = data.aws_subnets.ssx_public_subnets.ids
  launch_configuration = aws_launch_configuration.ecs_launch_config.name

  desired_capacity          = 1
  min_size                  = 1
  max_size                  = 10
  health_check_grace_period = 300
  health_check_type         = "EC2"
}