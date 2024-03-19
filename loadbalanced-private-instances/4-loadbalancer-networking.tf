# Public Subnets

resource "aws_subnet" "my_public_lb_subnet_1" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.5.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-2a"

  tags = {
    Name = "my_public_lb_subnet_1"
  }
}

resource "aws_subnet" "my_public_lb_subnet_2" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.6.0/24"
  map_public_ip_on_launch = true
  availability_zone       = "eu-west-2b"

  tags = {
    Name = "my_public_lb_subnet_2"
  }
}

# Create Public Route Table pointing to the IGW

resource "aws_route_table" "public_lb_route_table" {
  vpc_id = aws_vpc.my_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.my_igw.id
  }

  tags = {
    Name = "public_lb_route_table"
  }
}

# Associate public subnets with the Public Route Table

resource "aws_route_table_association" "public_lb_rta_1" {
  subnet_id      = aws_subnet.my_public_lb_subnet_1.id
  route_table_id = aws_route_table.public_lb_route_table.id
}

resource "aws_route_table_association" "public_lb_rta_2" {
  subnet_id      = aws_subnet.my_public_lb_subnet_2.id
  route_table_id = aws_route_table.public_lb_route_table.id
}