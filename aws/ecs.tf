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
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com",
        }
      }
    ]
  })
}
# Attach the AWS provided policy to the ecs_app_execution_role
resource "aws_iam_policy_attachment" "ecs_app_execution_role_attachment" {
  name = "ecs_app_execution_role_attachment"
  roles = [aws_iam_role.ecs_app_execution_role.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

# Role for running AWS EXEC - SSH into container directly for debugging
resource "aws_iam_role" "aws_exec_role" {
  name = "aws_exec_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      },
    ]
  })
  managed_policy_arns = [
    "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  ]
}

# The application task definition - this defines what the application
# is by default.
resource "aws_ecs_task_definition" "app_task_definition" {
  family = "app-task"
  network_mode = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn = aws_iam_role.ecs_app_execution_role.arn
  task_role_arn = aws_iam_role.aws_exec_role.arn

  container_definitions = jsonencode([{
    name = "app-task"
    image = "nginx:latest"
    portMappings = [{
      containerPort = 80
      hostPort = 80
      protocol = "tcp"
    }]
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
  desired_count = 3
  enable_execute_command = true

  load_balancer {
    target_group_arn = aws_alb_target_group.ecs_app_alb_target_group.arn
    container_name = aws_ecs_task_definition.app_task_definition.family
    container_port = 80
  }

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