data "aws_vpc" "ssx-prod" {
  filter {
    name   = "tag:Name"
    values = ["ssx-prod"]
  }
}

data "aws_subnets" "ssx_public_subnets" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.ssx-prod.id]
  }
  filter {
    name   = "tag:Name"
    values = ["ssx-prod-public-*"]
  }
}