## VPC setup

# fetch the default availability zones
data "aws_availability_zones" "azs" {
  state = "available"
}

# Create a new VPC to avoid using the default one
resource "aws_vpc" "main" {
  cidr_block = var.vpc_ip

  tags = {
    Name = "main-vpc"
  }
}

# Public Subnets
resource "aws_subnet" "public_1" {
  vpc_id = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.azs.names[0]
  cidr_block = cidrsubnet(var.vpc_ip, 4, 3)

  tags = {
    Name = "public-subnet-1"
  }
}

resource "aws_subnet" "public_2" {
  vpc_id = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.azs.names[1]
  cidr_block = cidrsubnet(var.vpc_ip, 4, 2)
  
  tags = {
    Name = "public-subnet-2"
  }
}

resource "aws_subnet" "public_3" {
  vpc_id = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.azs.names[2]
  cidr_block = cidrsubnet(var.vpc_ip, 4, 1)
  
  tags = {
    Name = "public-subnet-3"
  }
}

# Private Subnet
# No need to have private subnet for now

# Security Group
resource "aws_security_group" "ecs_sg" {
  name = "ecs-cluster-security-group"
  description = "Security Group for ECS cluster"
  vpc_id = aws_vpc.main.id

  # rules
  ingress {
    description = "Inbound rule - HTTPS only"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "Outbond rule - allow all traffic"
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ecs-cluster-sg"
  }
}