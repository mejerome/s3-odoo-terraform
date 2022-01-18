resource "aws_ecs_cluster" "odoo_ecs_cluster" {
  name = var.cluster_name
}