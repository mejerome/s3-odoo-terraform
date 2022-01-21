data "aws_ecs_task_definition" "odoo_db" {
  task_definition = aws_ecs_task_definition.odoo_db.family
  depends_on      = [aws_ecs_task_definition.odoo_db]
}
resource "aws_ecs_task_definition" "odoo_db" {
  family = "odoo_db"
  volume {
    name      = "odoodbvolume"
    host_path = "/mnt/efs/postgres"
  }
  network_mode          = "awsvpc"
  container_definitions = <<DEFINITION
[
  {
    "name": "odoo_db",
    "image": "docker.io/bitnami/postgresql:alpine",
    "essential": true,
    "portMappings": [
      {
        "containerPort": 5432
      }
    ],
    "environment": [
      {
        "name": "POSTGRES_DB",
        "value": "${var.odoo_db_name}"
      },
      {
        "name": "POSTGRES_USER",
        "value": "${var.odoo_db_user}"
      },
      {
        "name": "POSTGRES_PASSWORD",
        "value": "${var.db_password}"
      }
    ],
    "mountPoints": [
        {
          "readOnly": null,
          "containerPath": "/var/lib/postgresql/data",
          "sourceVolume": "odoodbvolume"
        }
    ],
    "logConfiguration": {
        "logDriver": "awslogs",
        "options": {
          "awslogs-group": "odoo_db",
          "awslogs-region": "${var.region}",
          "awslogs-stream-prefix": "ecs"
        }
    },
    "memory": 512,
    "cpu": 256
  }
]
DEFINITION
}
