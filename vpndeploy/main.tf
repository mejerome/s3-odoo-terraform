provider "aws" {
  profile = "default"
  region  = var.region
}

resource "aws_customer_gateway" "azure-cgw" {
  bgp_asn    = 65000
  ip_address = "172.83.124.10"
  type       = "ipsec.1"

  tags = {
    Name = "azure-cgw"
  }
}

resource "aws_vpn_gateway" "vpn_gw" {
  vpc_id = data.aws_vpc.ssx-prod.id

  tags = {
    Name = "azure-vpn-gw"
  }
}

resource "aws_route_table" "example" {
  vpc_id = data.aws_vpc.ssx-prod.id

  route {
    cidr_block = "10.100.2.0/24"
    gateway_id = aws_vpn_gateway.vpn_gw.id
  }

  tags = {
    Name = "azure-vpn-route-table"
  }
}
