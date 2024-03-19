######################################################

# CREATE VIRTUAL PRIVATE CLOUD (VPC) A

######################################################


# Virtual Private Cloud (VPC)

resource "aws_vpc" "my_vpc_a" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "MyVPC-A"
  }
}

# Create a public Internet Gateway

resource "aws_internet_gateway" "my_igw_a" {
  vpc_id = aws_vpc.my_vpc_a.id

  tags = {
    Name = "my_igw_a"
  }
}

# Public Subnets

resource "aws_subnet" "my_public_subnet_1_a" {
  vpc_id                  = aws_vpc.my_vpc_a.id
  cidr_block              = "10.0.0.0/24"
  map_public_ip_on_launch = true

  # Same AZ as it's peer to prevent incurring data transfer cost
  availability_zone = "us-east-1a"

  tags = {
    Name = "my_public_subnet_1_a"
  }
}

# Create Public Route Table pointing to the IGW

resource "aws_route_table" "public_route_table_a" {
  vpc_id = aws_vpc.my_vpc_a.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw_a.id
  }

  tags = {
    Name = "public_route_table_a"
  }
}

# Associate public subnets with the Public Route Table

resource "aws_route_table_association" "public_rta_1_a" {
  subnet_id      = aws_subnet.my_public_subnet_1_a.id
  route_table_id = aws_route_table.public_route_table_a.id
}
