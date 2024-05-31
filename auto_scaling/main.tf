# Terraform configuration file for creating an autoscaling group with launch template
# Variable for EC2 security group ID
variable "ec2_sg_id" {}

# Variable for subnet ID
variable "subnet_id"{} 

# Variable for AMI ID
variable "ami"{} 

# Variable for EC2 instance type
variable "ec2_type" {}

# Variable for target group ARN
variable "target_group_arn" {}

# Variable for user data
variable "user_data" {}

# Creating an AWS launch template resource
resource "aws_launch_template" "lt_project1" {
    name_prefix   = "lt-project1"  # Prefix for launch template name
    image_id      = var.ami  # AMI ID for the launch template
    instance_type = var.ec2_type  # EC2 instance type for the launch template
    key_name      = "my-key-pair"  # Key pair name for the launch template
    vpc_security_group_ids = [var.ec2_sg_id]  # Security group IDs for the launch template
    user_data     = var.user_data  # User data for the launch template
}

# Creating an AWS autoscaling group resource
resource "aws_autoscaling_group" "asg_project1" {
    name                      = "asg-project1"  # Name for the autoscaling group
    max_size                  = 6  # Maximum number of instances in the autoscaling group
    min_size                  = 2  # Minimum number of instances in the autoscaling group
    health_check_grace_period = 300  # Grace period for health checks
    health_check_type         = "ELB"  # Health check type
    desired_capacity          = 2  # Desired number of instances in the autoscaling group

    launch_template {
        id      = aws_launch_template.lt_project1.id  # ID of the launch template
        version = "$Latest"  # Latest version of the launch template
    }

    vpc_zone_identifier = var.subnet_id  # Subnet IDs for the autoscaling group
    target_group_arns   = [var.target_group_arn]  # Target group ARNs for the autoscaling group
}

# Creating an AWS key pair resource
resource "aws_key_pair" "key_pair_project1" {
    key_name   = "my-key-pair"  # Key pair name
    public_key = file("/home/aaqib/.ssh/id_rsa.pub")  # Path to the public key file
}
