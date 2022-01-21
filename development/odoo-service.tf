resource "aws_ecs_service" "odoo_app_service" {
  name                               = "odoo_app_service"
  iam_role                           = aws_iam_role.ecs-service-role.name
  cluster                            = aws_ecs_cluster.odoo_ecs_cluster.id
  task_definition                    = "${aws_ecs_task_definition.odoo_app.family}:${max("${aws_ecs_task_definition.odoo_app.revision}", "${data.aws_ecs_task_definition.odoo_app.revision}")}"
  depends_on                         = [aws_ecs_service.odoo_db_service]
  desired_count                      = var.desired_capacity
  deployment_minimum_healthy_percent = "50"
  deployment_maximum_percent         = "100"
  lifecycle {
    ignore_changes = [task_definition]
  }

  load_balancer {
    target_group_arn = aws_alb_target_group.odoo_app_target_group.arn
    container_port   = 80
    container_name   = "odoo_app"
  }
}

