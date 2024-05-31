# This file contains the variables that are used in the main.tf file
# define the variables
vpc_cidr_block = "10.0.0.0/16"
vpc_name = "project1"
pub_subnet_cidr_blocks = ["10.0.1.0/24", "10.0.2.0/24"]
pri_subnet_cidr_blocks = ["10.0.3.0/24", "10.0.4.0/24"]
availability_zones = ["us-west-2a", "us-west-2b"]
ec2_type = "t2.micro"
ami = "ami-0cf2b4e024cdb6960"

