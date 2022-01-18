terraform {
  backend "s3" {
    bucket = "jeromestorage"
    key    = "pre-prod/terraform.tfstate"
    region = "us-east-1"
  }
  required_providers {
    aws = ">= 3.70.0"
  }
  required_version = ">= 1.1.0"
}