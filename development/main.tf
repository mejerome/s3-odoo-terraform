data "aws_db_instance" "odoo-db" {
  db_instance_identifier = "odoodatabase"
}

resource "aws_ecs_cluster" "odoo-dev" {
  name = "odoo-dev"
  tags = {
    Name = "odoo-dev"
  }
}

resource "aws_cloudwatch_log_group" "odoo-logs" {
  name = "odoo-logs"
  tags = {
    Name = "odoo-logs"
  }
}
resource "aws_ecs_task_definition" "odoo_td" {
  family                   = "odoo-dev"
  container_definitions    = file("./task-definition.json")
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  cpu                      = "1024"
  memory                   = "2048"
  execution_role_arn       = aws_iam_role.ecs_agent.arn
  task_role_arn            = aws_iam_role.ecs_agent.arn

  tags = {
    Name = "odoo-dev"
  }
}
resource "aws_ecs_service" "odoo-dev" {
  name                = "odoo-dev"
  cluster             = aws_ecs_cluster.odoo-dev.id
  task_definition     = aws_ecs_task_definition.odoo_td.arn
  launch_type         = "FARGATE"
  scheduling_strategy = "REPLICA"
  desired_count       = 1

  network_configuration {
    subnets          = data.aws_subnets.ssx_public_subnets.ids
    security_groups  = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
  tags = {
    Name = "odoo-dev"
  }
  load_balancer {
    container_name   = "odoo-app"
    container_port   = 80
    target_group_arn = aws_lb_target_group.target-group.arn
  }
  depends_on = [aws_lb_listener.listener]
}

