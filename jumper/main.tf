# This file contains the Terraform configuration for the jumper instance.
variable "ami" {}  # AMI ID for the EC2 instance
variable "jumper_sg_id" {}  # Security Group ID for the jumper instance
variable "subnet_id" {}  # Subnet ID for the jumper instance

# Creating an AWS EC2 instance resource for the jumper instance
resource "aws_instance" "jumper" {
    ami                          = var.ami  # Use the specified AMI ID
    instance_type                = "t2.micro"  # Use a t2.micro instance type
    key_name                     = "my-key-pair"  # Use the specified key pair
    security_groups              = [var.jumper_sg_id]  # Use the specified security group
    subnet_id                    = var.subnet_id  # Use the specified subnet
    associate_public_ip_address  = true  # Assign a public IP address to the instance
}