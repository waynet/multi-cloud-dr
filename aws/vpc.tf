### The terraform VPC (Virtual Private Network) file
# Data source aws_availability_zones
# Resource:
#   aws_vpc
#   aws_subnet
#   aws_security_group

# fetch the default availability zones
data "aws_availability_zones" "azs" {
  state = "available"
}

# Create a new VPC to avoid using the default one
resource "aws_vpc" "main" {
  cidr_block = var.vpc_ip
  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "main-vpc"
  }
}

# Public Subnets
# Public subnets are used to host internet facing applications
# Public subnet 1
resource "aws_subnet" "public_1" {
  vpc_id = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.azs.names[0]
  cidr_block = cidrsubnet(var.vpc_ip, 4, 3)

  tags = {
    Name = "public-subnet-1"
  }
}

# Public subnet 2
resource "aws_subnet" "public_2" {
  vpc_id = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.azs.names[1]
  cidr_block = cidrsubnet(var.vpc_ip, 4, 2)
  
  tags = {
    Name = "public-subnet-2"
  }
}

# Public subnet 3
resource "aws_subnet" "public_3" {
  vpc_id = aws_vpc.main.id
  availability_zone = data.aws_availability_zones.azs.names[2]
  cidr_block = cidrsubnet(var.vpc_ip, 4, 1)
  
  tags = {
    Name = "public-subnet-3"
  }
}

# Private Subnet
# Private subnets are used to host backend/database applications
# No need to have private subnet for now

# Security Group - Firewall for the application
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
  
  ingress {
    description = "Inbound rule - HTTP only"
    from_port = 80
    to_port = 80
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

# Internet Gateway for the VPC public subnets
# This will give the application access to the internet
resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.main.id
}

# Route table for the application to reach the internet
resource "aws_route_table" "to_igw" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
}

# Attach the route table to the public subnets
resource "aws_route_table_association" "public_subnet1_route" {
  subnet_id = aws_subnet.public_1.id
  route_table_id = aws_route_table.to_igw.id
}
resource "aws_route_table_association" "public_subnet2_route" {
  subnet_id = aws_subnet.public_2.id
  route_table_id = aws_route_table.to_igw.id
}
resource "aws_route_table_association" "public_subnet3_route" {
  subnet_id = aws_subnet.public_3.id
  route_table_id = aws_route_table.to_igw.id
}