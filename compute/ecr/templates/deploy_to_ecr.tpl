# #!/bin/bash

# Variables
REGION="${region}"
ACCOUNT_ID="${account_id}"
REPOSITORY_NAME="${repository_name}"

# Get ECR login
aws ecr get-login-password --region $REGION | docker login --username AWS --password-stdin $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com

# Build the Docker image
docker build -t $REPOSITORY_NAME -f application/Dockerfile .

# Tag the Docker image
docker tag $REPOSITORY_NAME:latest $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPOSITORY_NAME:latest

# Push the Docker image
docker push $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPOSITORY_NAME:latest
