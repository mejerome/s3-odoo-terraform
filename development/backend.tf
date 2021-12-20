terraform {
  backend "s3" {
    bucket = "jeromestorage"
    key    = "ssx-terraform-active.tfstate"
    region = "us-east-1"
  }
}