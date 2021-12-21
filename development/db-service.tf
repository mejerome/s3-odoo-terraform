resource "aws_ecs_service" "odoo_db_service" {
  name            = "odoo_db_service"
  cluster         = aws_ecs_cluster.odoo_ecs_cluster.id
  task_definition = "${aws_ecs_task_definition.odoo_db.family}:${max("${aws_ecs_task_definition.odoo_db.revision}", "${data.aws_ecs_task_definition.odoo_db.revision}")}"
  desired_count   = 1
  depends_on      = [aws_lb.odoo_nw_load_balancer]

  load_balancer {
    target_group_arn = aws_lb_target_group.odoo_db_target_group.arn
    container_port   = 5432
    container_name   = "odoo_db"
  }

  network_configuration {
    subnets         = [aws_subnet.web-subnet-1.id, aws_subnet.web-subnet-2.id]
    security_groups = [aws_security_group.odoo_sg.id, aws_security_group.https_sg.id]
  }
}