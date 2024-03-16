This configuration creates a VPC with an Internet Gateway and a NAT Gateway for internet access. There are two public subnets, which the NAT Gateway uses, and two private subnets, where each hosts an EC2 instance. The route tables direct traffic from the private subnets through the NAT Gateway and traffic from the public subnets directly to the Internet Gateway.

Desgin consideration:
- Only one region is selected
- Region selected is London eu-west-2

You can choose how to divide up you VPC's subnets using this handy Subnet Calculator: https://www.davidc.net/sites/default/subnets/subnets.html
