# AWS Lambda

- A serverless code that runs when triggered.
- For example you upload a video to S3	, this will trigger the lambda to convert the video in different resolutions and store it in a different S3 bucket with the 3 different resolutions. 
- Another example is the use of updating NoSQL via API gateway.
- Severless, event-driven, supports many languages, high availability and automatically scales with workload.

You can find a simple Python example here: https://spacelift.io/blog/terraform-aws-lambda

For a more comprehensive example, please view the following where we will deploy a NodeJS function to AWS Lambda, and then expose that function to the Internet using Amazon API Gateway. This infrustructure is based from the official Hashicop website: https://developer.hashicorp.com/terraform/tutorials/aws/lambda-api-gateway

