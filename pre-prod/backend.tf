terraform {
  backend "s3" {
    bucket = "jeromestorage"
    key    = "pre-prod/terraform.tfstate"
    region = "us-east-1"
  }
}