# VPC 
data "aws_vpc" "nginx-vpc" {
  filter {
    name   = "tag:Name"
    values = ["VPC-1"]
  }
}

# Subnet
data "aws_subnet" "nginx_server" {
  filter {
    name   = "tag:Name"
    values = ["Subnet3"]
  }
}

#IGW
data "aws_internet_gateway" "default" {
  filter {
    name   = "tag:Name"
    values = ["igw1"]
  }
}

#Route Table
resource "aws_route_table" "prod-public-crt" {
  vpc_id = data.aws_vpc.nginx-vpc.id
  route {
    cidr_block = "0.0.0.0/0"                          //associated subnet can reach everywhere
    gateway_id = data.aws_internet_gateway.default.id //CRT uses this IGW to reach internet
  }
  tags = {
    Name = "prod-public-crt"
  }
}
resource "aws_route_table_association" "prod-crta-public-subnet-1" {
  subnet_id      = data.aws_subnet.nginx_server.id
  route_table_id = aws_route_table.prod-public-crt.id
}

