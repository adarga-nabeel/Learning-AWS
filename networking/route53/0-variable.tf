variable "domain_name" {
  description = "Domain name e.g. personal.com"
  type        = string
  default     = ""
}

variable "update_hosted_zone" {
  default = false
  type    = bool
}
