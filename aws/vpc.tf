## VPC setup

# fetch the default availability zones
data "aws_availability_zones" "azs" {
  state = "available"
}

# Create a new VPC to avoid using the default one
resource "aws_vpc" "main" {
  cidr_block = var.vpc_ip

  tags = {
    "Name" = "main_vpc"
  }
}

# Public Subnets
resource "aws_subnet" "public_1" {
  vpc_id = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.azs.names[0]
  cidr_block = cidrsubnet(var.vpc_ip, 4, 3)

  tags = {
    "Name" = "public_subnet_1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.azs.names[1]
  cidr_block = cidrsubnet(var.vpc_ip, 4, 2)
  
  tags = {
    "Name" = "public_subnet_2"
  }
}

resource "aws_subnet" "public_3" {
  vpc_id = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.azs.names[2]
  cidr_block = cidrsubnet(var.vpc_ip, 4, 1)
  
  tags = {
    "Name" = "public_subnet_3"
  }
}

# Private Subnet

# Security Group