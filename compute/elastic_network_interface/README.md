# Elastic Network Interface (ENI)

- A virtual network interface that can be attached to an EC2 instance to enable networking in a VPC.
- There is primary ENI (comes with EC2 instance) and secondary ENI that are additional.
- Secondary ENI can have multiple IP addresses.
- Can associate an elastic IP address (static IP) with the ENI
- Can assign Security groups to the ENI restricting what traffic can go IN and OUT of its attached resource.
- Secondary ENI’s can be attached and detached to EC2 instances without requiring it to restart.
- Flow logs can be enabled on ENI to capture information on IP traffic going to and from the ENI
