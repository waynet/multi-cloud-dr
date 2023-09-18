## Output for some info testing

output "test" {
  value = data.aws_availability_zones.azs.names[0]
}