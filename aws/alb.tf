### The Terraform Application Load Balancer
# Resource:
#   aws_alb
#   aws_lb_target_group
#   aws_lb_listener

# Security Group - Firewall for the application load balancer
# alb accepts both HTTP and HTTPS traffic
resource "aws_security_group" "app_lb_sg" {
  name = "app-lb-security-group"
  description = "Security Group for application load balancer"
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
    Name = "app-lb-sg"
  }
}

# The load balancer for the ECS application
# alb will balance traffic into 3 different subnets
resource "aws_alb" "ecs_app_load_balancer" {
  name = "app-load-balancer"
  load_balancer_type = "application"
  subnets = [aws_subnet.public_1.id, aws_subnet.public_2.id, aws_subnet.public_3.id]
  security_groups = [aws_security_group.app_lb_sg.id]
}

# The target group that the alb will direct traffic into
resource "aws_alb_target_group" "ecs_app_alb_target_group" {
    name = "app-target-group"
    port = 80
    protocol = "HTTP"
    target_type = "ip"
    vpc_id = aws_vpc.main.id
    health_check {
      matcher = "200"
      path = "/"
    }
}

# alb listener - Forward HTTPS traffic
resource "aws_alb_listener" "ecs_app_alb_listener_https" {
  load_balancer_arn = aws_alb.ecs_app_load_balancer.arn
  port = "443"
  protocol = "HTTPS"
  ssl_policy = "ELBSecurityPolicy-2016-08"
  certificate_arn = "arn:aws:acm:eu-west-1:311945118196:certificate/2d6e6ffa-fe93-4e5f-95c8-4f5e46f9ff5c"
  
  default_action {
    type = "forward"
    target_group_arn = aws_alb_target_group.ecs_app_alb_target_group.arn
  }
}

# alb listener - redirect HTTP traffic to HTTPS
resource "aws_alb_listener" "ecs_app_alb_listener_http" {
  load_balancer_arn = aws_alb.ecs_app_load_balancer.arn
  port = "80"
  protocol = "HTTP"
  
  default_action {
    type = "redirect"
    redirect {
      protocol = "HTTPS"
      port = "443"
      status_code = "HTTP_301"
    }
  }
}