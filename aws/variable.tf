## List of hard-coded values for terraform
## these are not secret

variable "env_name" {
  description = "The AWS environment name"
  type = string
  default = "aws-app-env"
}