### The terraform variable file 
# List of hard-coded values for terraform
# these are not secret

variable "env_name" {
  description = "The AWS environment name"
  type = string
  default = "aws-app-env"
}

variable "vpc_ip" {
  description = "The VPC IP address using cidr notation"
  type = string
  default = "10.0.0.0/24"
}