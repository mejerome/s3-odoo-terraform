terraform {
  backend "s3" {
    bucket = "jeromestorage"
    key    = "development/terraform.tfstate"
    region = "us-east-1"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 4.9.0"
    }
  }
}