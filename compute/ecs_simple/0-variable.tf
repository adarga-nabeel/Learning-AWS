variable "name" {
  description = "Project name"
  type = string
  default = "Fargate_ECS"
}

variable "region" {
  description = "Specify AWS region"
  type = string
  default = "us-east-1"
}

variable "app_count" {
    description = "Number of docker containers to run"
    default = 2
}

variable "app_image" {
    description = "Docker image to run in the ECS cluster"
    default = "docker/getting-started"
}

variable "app_port" {
  description = "application port number"
  type = string
  default = 80
}

variable "fargate_cpu" {
    description = "Fargate instance CPU units to provision (1 vCPU = 1024 CPU units)"
    default = "1024"
}

variable "fargate_memory" {
    description = "Fargate instance memory to provision (in MiB)"
    default = "2048"
}