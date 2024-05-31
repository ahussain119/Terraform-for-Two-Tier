# This Terraform configuration file creates three security groups in the VPC:
variable "vpc_id" {} # Variable for VPC ID

# Output for EC2 security group ID
output "ec2_sg_id" {
  value = aws_security_group.ec2_sg.id
}

# Output for Load Balancer security group ID
output "LB_sg_id" {
  value = aws_security_group.LB-sg.id  
}

# Output for jumper security group ID
output "jumper_sg_id" {
  value = aws_security_group.jumper-sg.id  
}

# Creating an EC2 security group and allowing SSH and HTTP traffic from the jumper and Load Balancer security groups
resource "aws_security_group" "ec2_sg" {
  vpc_id = var.vpc_id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    security_groups = [aws_security_group.jumper-sg.id]
  }
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    security_groups = [aws_security_group.LB-sg.id]
  }
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ec2-sg-22-80"
  }
}

# Creating a Load Balancer security group and allowing HTTP traffic
resource "aws_security_group" "LB-sg" {
  vpc_id = var.vpc_id
  ingress {
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  } 
  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "LB-sg-80"
  }
}

# Creating a jumper security group and allowing SSH traffic
resource "aws_security_group" "jumper-sg" {
  vpc_id = var.vpc_id
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
    egress {
        from_port = 0
        to_port = 0
        protocol = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }

  tags = {
    Name = "jumper-sg-22"
  }
}