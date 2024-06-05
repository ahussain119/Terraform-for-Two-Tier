# Purpose: Terraform configuration file for creating an AWS load balancer
variable "lb_sg_id" {}  # Variable for the load balancer security group ID
variable "public_subnet_ids" {}  # Variable for the public subnet IDs
variable "vpc_id" {}  # Variable for the VPC ID
variable "certificate_arn" {}  # Variable for the certificate ARN
variable "certificate_validation" {}  # Variable for the certificate validation

output "tg_arn" {
    value = aws_lb_target_group.tg-project1.arn  # Output for the target group ARN
}

output "lb_zone_id" {
    value = aws_lb.lb-project1.zone_id
}

output "front_end" {
    value = aws_lb_listener.front_end  
}

output "lb_dns_name" {
    value = aws_lb.lb-project1.dns_name
}

# Creating an AWS load balancer resource
resource "aws_lb" "lb-project1" {
    name               = "lb-project1"
    internal           = false
    load_balancer_type = "application"
    security_groups    = [var.lb_sg_id]  # Assigning the load balancer security group ID
    subnets            = var.public_subnet_ids  # Assigning the public subnet IDs
    

    enable_deletion_protection = false

    tags = {
        Environment = "production"
    }
}

# Creating an AWS load balancer target group resource
resource "aws_lb_target_group" "tg-project1" {
    name     = "tg-project1"
    port     = 80
    protocol = "HTTP"
    vpc_id   = var.vpc_id  # Assigning the VPC ID
}

# Creating an AWS load balancer listener resource
resource "aws_lb_listener" "front_end" {
    depends_on = [ var.certificate_validation ]
    load_balancer_arn = aws_lb.lb-project1.arn
    port              = "443"
    protocol          = "HTTPS"
    certificate_arn = var.certificate_arn
    default_action {
        type             = "forward"
        target_group_arn = aws_lb_target_group.tg-project1.arn
    }
}
