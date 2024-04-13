# Virtual Private Cloud (VPC)

resource "aws_vpc" "main" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = var.name
  }
}

# Create a public Internet Gateway

resource "aws_internet_gateway" "my_igw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.name}_igw"
  }
}

# Public Subnets

resource "aws_subnet" "my_public_subnet_1" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, 1) #"10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}a"

  tags = {
    Name = "${var.name}-public-${var.region}a"
  }
}

resource "aws_subnet" "my_public_subnet_2" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(aws_vpc.main.cidr_block, 8, 2) #"10.0.2.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "${var.region}b"

  tags = {
    Name = "${var.name}-public-${var.region}b"
  }
}

# Create Public Route Table pointing to the IGW

resource "aws_route_table" "public_route_table" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "public_route_table"
  }
}

# Associate public subnets with the Public Route Table

resource "aws_route_table_association" "public_rta_1" {
  subnet_id      = aws_subnet.my_public_subnet_1.id
  route_table_id = aws_route_table.public_route_table.id
}

resource "aws_route_table_association" "public_rta_2" {
  subnet_id      = aws_subnet.my_public_subnet_2.id
  route_table_id = aws_route_table.public_route_table.id
}
