# Virtual Private Cloud (VPC)

resource "aws_vpc" "vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "custom_VPC"
  }
}

# Create a public Internet Gateway

resource "aws_internet_gateway" "internet_gateway" {
  vpc_id = aws_vpc.vpc.id

  tags = {
    Name = "Internet_Gateway"
  }
}

# Public Subnets

data "aws_availability_zones" "available" {}

resource "aws_subnet" "subnet" {
  # Create a counter based on the number of AZ on the region
  count = length(data.aws_availability_zones.available.names)

  # cidrsubnet(
  # 1) full CIDR block, 
  # 2 prefix length i.e. number of additional bites to add /16 + 8 = /24)
  # 3) gives a count for each subnet)
  cidr_block = cidrsubnet(aws_vpc.vpc.cidr_block, 8, count.index)

  # Specify the VPC the subnets will be based on
  vpc_id = aws_vpc.vpc.id

  # Specify the AZ that subnets will be created in
  availability_zone = data.aws_availability_zones.available.names[count.index]

  # Name of each subnet
  tags = {
    Name = data.aws_availability_zones.available.names[count.index]
  }
}


# Create Public Route Table pointing to the IGW

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.internet_gateway.id
  }

  tags = {
    Name = "public_route_table"
  }
}

# Associate public subnets with the Public Route Table

resource "aws_route_table_association" "vpc_public_assoc" {
  # Create a counter based on the number of AZ on the region
  count = length(data.aws_availability_zones.available.names)

  # Extract the subnets id's for each (*) created subnet
  subnet_id = aws_subnet.subnet.*.id[count.index]

  # Associate route with route table
  route_table_id = aws_route_table.public_route_table.id
}
