




# VPC and Subnets
resource "aws_vpc" "nexacloud_vpc" {
  cidr_block = "10.0.0.0/16"
}
# public subnet for the VPC
resource "aws_subnet" "nexacloud_net_public" {
  vpc_id                  = aws_vpc.nexacloud_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true
  tags = {
    Name   = "public-subnet-us-east-1a",
    subnet = "public"
  }
}
# private subnet for the VPC
resource "aws_subnet" "nexacloud_net_private" {
  vpc_id     = aws_vpc.nexacloud_vpc.id
  cidr_block = "10.0.0.0/24"
  tags = {
    Name   = "private-subnet-us-east-1a",
    subnet = "private"
  }
}

# Internet Gateway (for public access)
resource "aws_internet_gateway" "igw_nexacloud" {
  vpc_id = aws_vpc.nexacloud_vpc.id
  tags = {
    Name = "nexacloud-igw"
  }
}

# 5. Public Route Table
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.nexacloud_vpc.id

  route {
    cidr_block = "0.0.0.0/0" # Route all traffic to the internet
    gateway_id = aws_internet_gateway.igw_nexacloud.id
  }
  tags = {
    Name = "public-route-table"
  }
}

# 6. Association of Public Subnet with Public Route Table
resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id      = aws_subnet.nexacloud_net_public.id
  route_table_id = aws_route_table.public_rt.id
}

# 7. Elastic IP for NAT Gateway (needed before NAT Gateway)
resource "aws_eip" "nat_gateway_eip" {
  domain = "vpc" # Required for NAT Gateway EIPs
}

# 8. NAT Gateway (for private subnet outbound internet access)
resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_gateway_eip.id
  subnet_id     = aws_subnet.nexacloud_net_public.id # NAT GW must be in a public subnet
  tags = {
    Name = "nexacloud-nat-gw"
  }
}

# 9. Private Route Table
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.nexacloud_vpc.id

  route {
    cidr_block     = "0.0.0.0/0" # Route all traffic to the NAT Gateway
    nat_gateway_id = aws_nat_gateway.nat_gw.id
  }
  tags = {
    Name = "private-route-table"
  }
}

# 10. Association of Private Subnet with Private Route Table
resource "aws_route_table_association" "private_rt_assoc" {
  subnet_id      = aws_subnet.nexacloud_net_private.id
  route_table_id = aws_route_table.private_rt.id
}