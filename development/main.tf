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
  family                = "odoo-dev"
  container_definitions = file("./task-definition.json")

  execution_role_arn = aws_iam_role.ecs_agent.arn
  task_role_arn      = aws_iam_role.ecs_agent.arn

  tags = {
    Name = "odoo-dev"
  }
}

resource "aws_ecs_service" "odoo-dev" {
  name            = "odoo-dev"
  cluster         = aws_ecs_cluster.odoo-dev.id
  task_definition = aws_ecs_task_definition.odoo_td.arn

  desired_count = 1
}