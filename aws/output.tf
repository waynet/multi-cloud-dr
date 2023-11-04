### The terraform output file
# Output for some info testing

# Availability zones
output "availability_zones" {
  value = data.aws_availability_zones.azs.names[0]
}

# Load balancer DNS name
output "alb_fqdn" {
  value = aws_alb.ecs_app_load_balancer.dns_name
}