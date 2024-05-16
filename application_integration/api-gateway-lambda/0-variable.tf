variable "name" {
  description = "Project name"
  type = string
  default = "get-cars"
}

variable "region" {
  description = "AWS region"
  type = string
  default = "us-east-1"
}

variable "endpoint_path" {
  description = "endpoint path for the API Gateway"
  type = string
  default = "cars"
}