### The terraform ECS (Elastic Container Service) cluster file
# Resource:
#   aws_ecs_cluster

# The ECS cluster
resource "aws_ecs_cluster" "app" {
  name = "application-cluster"
}

# The IAM role for ECS application
# This will allow ECS containers to assume the role
# and call other AWS api.
resource "aws_iam_role" "ecs_app_execution_role" {
  name = "ecs_app_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [{
      Action = "sts:AssumeRole",
      Effect = "Allow",
      Principal = {
        Service = "ecs-tasks.amazonaws.com",
      }
    }]
  })
}

# Attach the AWS provided policy to the ecs_app_execution_role
resource "aws_iam_policy_attachment" "ecs_app_execution_role_attachment" {
  name = "ecs_app_execution_role_attachment"
  roles = [aws_iam_role.ecs_app_execution_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# The application task definition - this defines what the application
# is by default.
resource "aws_ecs_task_definition" "app_task_definition" {
  family = "app-task"
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn = aws_iam_role.ecs_app_execution_role.arn

  container_definitions = jsonencode([{
    name = "app-container"
    image = "httpd:latest"
    portMappings = [{
      containerPort = 80
      hostPort = 80
      protocol = "tcp"
    }]
    essential = true
    entryPoint = ["sh", "-c"]
    command = ["/bin/sh -c \"echo '<html> <head> <title>Amazon ECS Sample App</title> <style>body {margin-top: 40px; background-color: #333;} </style> </head><body> <div style=color:white;text-align:center> <h1>Amazon ECS Sample App</h1> <h2>Congratulations!</h2> <p>Your application is now running on a container in Amazon ECS.</p> </div></body></html>' >  /usr/local/apache2/htdocs/index.html && httpd-foreground\""]
  }])
  cpu = 256
  memory = 512
}

# The ECS service running the application
resource "aws_ecs_service" "app_service" {
  name = "app-service"
  cluster = aws_ecs_cluster.app.id
  task_definition = aws_ecs_task_definition.app_task_definition.arn
  launch_type = "FARGATE"
  desired_count = 1

  network_configuration {
    subnets = [
      aws_subnet.public_1.id,
      aws_subnet.public_2.id,
      aws_subnet.public_3.id
    ]
    security_groups = [aws_security_group.ecs_sg.id]
    assign_public_ip = true
  }
}