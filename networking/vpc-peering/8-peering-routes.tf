resource "aws_route" "vpc_peering_requester" {
  route_table_id            = aws_route_table.public_route_table_a.id
  destination_cidr_block    = aws_subnet.my_public_subnet_1_b.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_requestor.id
}

resource "aws_route" "vpc_peering_accepter" {
  route_table_id            = aws_route_table.public_route_table_b.id
  destination_cidr_block    = aws_subnet.my_public_subnet_1_a.cidr_block
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_requestor.id
}