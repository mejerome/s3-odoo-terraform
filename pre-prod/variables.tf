variable "region" {
  description = "Deployment region"
  default     = "us-east-1"
}

variable "tag_name" {
  description = "Tag name"
}

variable "image_id" {
  description = "Bitnami image id"
  default     = "ami-084ab2148108d0e90" # ami-082a406c73ae55324 eu-central
}

variable "instance_type" {
  description = "Instance type"
  default     = "t3.small"
}

variable "key_name" {
  description = "Key name"
  default     = "odoo-key"
}

variable "key_file" {
  default = "../../odoo-key.pem"
}

variable "hosted_zone_id" {
  default = "Z1PSEXSC6MXGQ4"
}

variable "hosted_zone_name" {
  description = "Hosted zone name"
}

variable "root_volume_size" {
  description = "Size of root volume in GB"
  default     = "100"
}
