terraform {
  backend "s3" {
    bucket = "jeromestorage"
    key    = "ssx-terraform-dev.tfstate"
    region = "us-east-1"
  }
}