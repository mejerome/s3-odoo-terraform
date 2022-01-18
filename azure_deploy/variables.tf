variable "rg_name" {
  type        = string
  default     = "OdooERP"
  description = "Deployment resource group name"
}

variable "rg_location" {
  type    = string
  default = "eastus"
}

variable "addressprefix" {
  type    = string
  default = "10.0.0.0/16"
}

variable "computesubnetprefix" {
  type    = string
  default = "10.0.10.0/24"
}

variable "databasesubnetprefix" {
  type    = string
  default = "10.0.20.0/24"
}
variable "vnet_name" {
  type    = string
  default = "ssx-vnet"
}

variable "postgresql_admin_login" {
  type        = string
  description = "Odoo PostgreSQL admin login"
}

variable "postgresql_admin_password" {
  type        = string
  description = "Odoo PostgreSQL admin password"
}

