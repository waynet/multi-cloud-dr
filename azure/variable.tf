### The terraform variable file 
# List of hard-coded values for terraform
# these are not secret

variable "env_name" {
  description = "The Azure environment name"
  type = string
  default = "azure-app-env"
}

variable "vnet_ip" {
  description = "The VNet IP address using cidr notation"
  type = string
  default = "10.0.0.0/20"
}