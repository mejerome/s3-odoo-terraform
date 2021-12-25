
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
  count             = 3
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
  count          = 3
  subnet_id      = element(aws_subnet.public.*.id, count.index)
  route_table_id = aws_route_table.public.id
}