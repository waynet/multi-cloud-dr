### The terraform output file
# Output for some info testing

output "availability_zones" {
  value = data.aws_availability_zones.azs.names[0]
}

# output "app_ip" {
#   value = resource.aws_ecs_service.app_service.IP
# }