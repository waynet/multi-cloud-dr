### The main terraform file
# terraform required_providers
# terraform provider

# required terraform provider with version info
terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
}

# terraform provider configuration
provider "aws" {
  region = "eu-west-1"
}