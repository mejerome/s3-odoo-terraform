output "vpc_name" {
  value = data.aws_vpc.ssx-prod.tags["Name"]
}

output "ssx_public_subnets" {
  value = data.aws_subnet_ids.ssx_public_subnets.ids
}