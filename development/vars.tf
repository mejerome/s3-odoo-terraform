variable "tag_name" {
  default = "tf-ssx-odoo"
}

variable "region" {
  default = "eu-central-1"
}

variable "cluster_name" {
  description = "value of the cluster name"
}

variable "odoo_app_image" {
  description = "value of the odoo app image"
}

variable "key_name" {
  default = "odoo-key-eu"
}

variable "key_file" {
  default = "../../odoo-key-eu.pem"
}

variable "instance_type" {
  default = "t2.small"
}

variable "hosted_zone_id" {
  default = "Z1PSEXSC6MXGQ4"
}

variable "vpc_cidr_block" {
  type        = string
  description = "value of the VPC CIDR block"
}

variable "public_subnet_cidr" {
  type        = list(any)
  description = "CIDR blocks for public subnets"
}

variable "odoo_db_name" {
  type        = string
  description = "value of the odoo database name"
}

variable "odoo_db_user" {
  type        = string
  description = "value of the odoo database user"
}

variable "db_password" {
  type        = string
  description = "value of the odoo database password"
}

variable "max_instance_size" {
  description = "value of the max instance size"
}

variable "min_instance_size" {
  description = "value of the min instance size"
}

variable "desired_capacity" {
  description = "value of the desired capacity"
}