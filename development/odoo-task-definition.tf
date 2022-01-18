data "aws_ecs_task_definition" "odoo_app" {
  task_definition = aws_ecs_task_definition.odoo_app.family
  depends_on      = [aws_ecs_task_definition.odoo_app]
}

resource "aws_ecs_task_definition" "odoo_app" {
  family                = "odoo_app"
  container_definitions = <<DEFINITION
[
  {
    "name": "odoo_app",
    "image": "docker.io/bitnami/odoo:15",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 8069,
        "hostPort": 8069
      }
    ],
    "environment": [
      {
        "name": "ODOO_DATABASE_HOST",
        "value": "${aws_lb.odoo_nw_load_balancer.dns_name}"
      },
      {
        "name": "ODOO_DATABASE_ADMIN_USER",
        "value": "${var.odoo_db_user}"
      },
      {
        "name": "ODOO_DATABASE_ADMIN_PASSWORD",
        "value": "${var.db_password}"
      }
    ],
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "odoo_app",
          "awslogs-region": "${var.region}",
          "awslogs-stream-prefix": "ecs"
        }
    },
    "memory": 1024,
    "cpu": 1024
  }
]
DEFINITION
}