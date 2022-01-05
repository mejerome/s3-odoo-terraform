
data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_vpc" "vpc" {
  cidr_block           = "10.20.0.0/16"
  enable_dns_hostnames = true
  tags = {
    Name = var.tag_name
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.vpc.id
  tags = {
    Name = var.tag_name
  }
}

resource "aws_subnet" "public" {
  count             = length(data.aws_availability_zones.available.names)
  vpc_id            = aws_vpc.vpc.id
  cidr_block        = "10.20.${10 + count.index}.0/24"
  availability_zone = element(data.aws_availability_zones.available.names, count.index)
  depends_on = [
    aws_internet_gateway.igw,
  ]
  map_public_ip_on_launch = true
  tags = {
    Name = var.tag_name
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

resource "aws_route_table_association" "public" {
  count          = length(data.aws_availability_zones.available.names)
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}

resource "aws_network_interface" "odoo_nic" {
  subnet_id      = aws_subnet.public.0.id
  security_groups = [
    aws_security_group.allow_http.id,
    aws_security_group. allow_https.id,
    aws_security_group.allow_ssh.id,
  ]
  tags = {
    Name = "primary_nic"
  }
}

resource "aws_route53_record" "ssxodoo" {
  zone_id = var.hosted_zone_id
  name    = var.hosted_zone_name
  type    = "CNAME"
  ttl     = "300"

  records = [
    aws_instance.ssxodoo.public_dns,
  ]

  depends_on = [
    aws_instance.ssxodoo,
  ]
}