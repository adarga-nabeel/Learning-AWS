# CAPTURE THE AWS ACCOUNT ID OF THE TARGET PEER VPC

# data "aws_vpc" "target_vpc_data" {
#   id = aws_vpc.my_vpc_b.id
# }

# output "target_vpc_id" {
#   value = data.aws_vpc.target_vpc_data.owner_id
# }


data "aws_caller_identity" "target_vpc_account" {}
data "aws_region" "current" {}

output "target_account_id" {
  value = data.aws_caller_identity.target_vpc_account.account_id
}

output "vpc_a_id" {
  value = aws_vpc.my_vpc_a.id
}

output "vpc_b_id" {
  value = aws_vpc.my_vpc_b.id
}

# REQUESTING VPC
resource "aws_vpc_peering_connection" "vpc_requestor" {
  vpc_id        = aws_vpc.my_vpc_a.id                                    # Requesting VPC ID 
  peer_vpc_id   = aws_vpc.my_vpc_b.id                                    # Target (Accepting) VPC ID
  peer_owner_id = data.aws_caller_identity.target_vpc_account.account_id # The AWS account ID of the target peer VPC.

  # peer_region = data.aws_region.current.name # `peer_region` cannot be set whilst `auto_accept` is `true`
  auto_accept = true

  tags = {
    Side = "Requester"
  }
}

# TARGET/ACCESPING VPC
resource "aws_vpc_peering_connection_accepter" "peer" {
  vpc_peering_connection_id = aws_vpc_peering_connection.vpc_requestor.id
  auto_accept               = true

  tags = {
    Side = "Accepter"
  }
}
