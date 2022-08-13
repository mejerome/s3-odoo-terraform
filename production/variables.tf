variable "tag_name" {
  description = "Deployment tag name"
  type        = string
}

variable "odoo_ami" {
  description = "AMI ID"
  type        = string
}

variable "root_volume_size" {
  description = "Root volume size"
  default     = 100
}
variable "db_username" {
  type        = string
  description = "odoo database username"
}

variable "db_password" {
  type        = string
  description = "odoo database password"
}

variable "region" {
  type        = string
  description = "AWS region"
}

variable "key_name" {
  type        = string
  description = "AWS key name"
  default     = "odoo-key"
}

variable "key_file" {
  default = "../../odoo-key.pem"
}

variable "hosted_zone_id" {
  type        = string
  description = "AWS DNS zone name"
}

variable "hosted_zone_name" {
  type        = string
  description = "AWS DNS zone name"
}