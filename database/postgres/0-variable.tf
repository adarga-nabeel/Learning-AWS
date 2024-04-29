variable "name" {
  type = string
  default = "postgres"
}

variable "region" {
  type = string
  default = "us-east-1"
}

variable "db-username" {
  type = string
}
variable "db-password" {
  type = string
}