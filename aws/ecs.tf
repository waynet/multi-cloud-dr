### The terraform ECS cluster file
# Resource:
#   aws_ecs_cluster

resource "aws_ecs_cluster" "app" {
  name = "application-cluster"
}