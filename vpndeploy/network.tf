data "aws_vpc" "ssx-prod" {
  filter {
    name   = "tag:Name"
    values = ["ssx-prod"]
  }
}

data "aws_subnet_ids" "ssx_public_subnets" {
  vpc_id = data.aws_vpc.ssx-prod.id
  filter {
    name   = "tag:Name"
    values = ["ssx-prod-public-*"]
  }
}

