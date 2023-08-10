## VPC setup

# fetch the default availability zones
data "aws_availability_zones" "azs" {
  state = "available"
}