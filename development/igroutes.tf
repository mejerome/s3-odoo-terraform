resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.ssx-vpc.id

  tags = {
    Name = var.tag_name
  }
}

resource "aws_route_table" "web-rt" {
  vpc_id = aws_vpc.ssx-vpc.id


  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

  tags = {
    Name = var.tag_name
  }
}
