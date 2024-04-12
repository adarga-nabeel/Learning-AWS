# Elastic Network Interface (ENI)

- A virtual network interface that can be attached to an EC2 instance to enable networking in a VPC.
- There is primary ENI (comes with EC2 instance) and secondary ENI that are additional.
- Secondary ENI can have multiple IP addresses.
- Can associate an elastic IP address (static IP) with the ENI
- Can assign Security groups to the ENI restricting what traffic can go IN and OUT of its attached resource.
- Secondary ENI’s can be attached and detached to EC2 instances without requiring it to restart.
- Flow logs can be enabled on ENI to capture information on IP traffic going to and from the ENI

# AWS Flow Log
Provides a VPC/Subnet/ENI/Transit Gateway/Transit Gateway Attachment Flow Log to capture IP traffic for a specific network interface, subnet, or VPC. Logs are sent to a CloudWatch Log Group, a S3 Bucket, or Amazon Kinesis Data Firehose.

## VPC Flow logs may be defined at one of the three different scopes:
- VPC level: This will monitor logs for every subnet and every network interface within that VPC.
- Subnet level: This will monitor every interface within that subnet.
- Elastic Network Interface(ENI) level: This will monitor only that specific interface. This includes being created to support AWS service objects connected to your VPCs.

For more information, please read this (article)[https://devopslearning.medium.com/vpc-flow-logs-45eca8ae718b]