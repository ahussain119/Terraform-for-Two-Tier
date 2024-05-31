# Purpose: Define the variables that will be used in the Terraform configuration
variable "ami" {
    type = string
    description = "the AMI to be used"
}


variable "ec2_type" {
    type = string
    description = "the type of EC2 instance"
}

variable "vpc_cidr_block" {
    type = string
    description = "the CIDR block for the VPC"
}

variable "vpc_name" {
    type = string
    description = "the name of the VPC" 
}

variable "pub_subnet_cidr_blocks" {
    type = list(string)
    description = "the CIDR blocks for the public subnets" 
}

variable "pri_subnet_cidr_blocks" {
    type = list(string)
    description = "the CIDR blocks for the private subnets"
}

variable "availability_zones" {
    type = list(string)
    description = "the availability zones for the subnets"  
}
