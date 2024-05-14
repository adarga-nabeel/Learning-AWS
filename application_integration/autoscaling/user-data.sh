#!/bin/bash

# Update yum package manager
sudo yum update -y

# Install docker package
sudo yum install docker -y

# Start docker daemon
sudo service docker start

# Add the ec2-user to the docker group so you can execute Docker commands without using sudo.
sudo usermod -a -G docker ec2-user

# Install docker-compose
sudo curl -L https://github.com/docker/compose/releases/latest/download/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose

sudo chmod +x /usr/local/bin/docker-compose

sleep 2

# setup hello world server container
curl -sL https://gitlab.com/-/snippets/2565205/raw/main/treafik_whoami.sh | sudo bash