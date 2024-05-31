# This Terraform configuration file creates a VPC with public and private subnets, internet gateway, route tables, and NAT gateway.
variable "vpc_cidr_block" {}  # Variable for VPC CIDR block
variable "vpc_name" {}  # Variable for VPC name
variable "pub_subnet_cidr_blocks" {}  # Variable for public subnet CIDR blocks
variable "availability_zones" {}  # Variable for availability zones
variable "pri_subnet_cidr_blocks" {}  # Variable for private subnet CIDR blocks

output "vpc_id" {
  value = aws_vpc.vpcProject1.id  # Output for VPC ID
}

output "private_subnet_ids" {
  value = aws_subnet.Project1_Pri_subnets[*].id # Output for private subnet IDs
}

output "public_subnet_ids" {
  value = aws_subnet.Project1_Pub_subnets[*].id  # Output for public subnet IDs
}

output "public_subnet_jumper" {
  value = aws_subnet.Project1_Pub_subnets[0].id  # Output for the first public subnet ID
}



# Creating an AWS VPC resource
resource "aws_vpc" "vpcProject1" {
  cidr_block = var.vpc_cidr_block  # VPC CIDR block
  tags = {
    Name = var.vpc_name  # VPC name
  }
}

# Creating AWS public subnets
resource "aws_subnet" "Project1_Pub_subnets" {
  count = length(var.pub_subnet_cidr_blocks)  # Create multiple public subnets based on the count of CIDR blocks
  vpc_id = aws_vpc.vpcProject1.id  # VPC ID
  cidr_block = element(var.pub_subnet_cidr_blocks, count.index)  # Public subnet CIDR block
  availability_zone = element(var.availability_zones, count.index)  # Availability zone

  tags = {
    Name = "${var.vpc_name}-pub-subnet-${count.index + 1}"  # Public subnet name
  }
}

# Creating AWS private subnets
resource "aws_subnet" "Project1_Pri_subnets" {
  count = length(var.pri_subnet_cidr_blocks)  # Create multiple private subnets based on the count of CIDR blocks
  vpc_id = aws_vpc.vpcProject1.id  # VPC ID
  cidr_block = element(var.pri_subnet_cidr_blocks, count.index)  # Private subnet CIDR block
  availability_zone = element(var.availability_zones, count.index)  # Availability zone

  tags = {
    Name = "${var.vpc_name}-pri-subnet-${count.index + 1}"  # Private subnet name
  }
}

# Creating an AWS internet gateway resource
resource "aws_internet_gateway" "igw_project1" {
  vpc_id = aws_vpc.vpcProject1.id  # VPC ID
  tags = {
    Name = "${var.vpc_name}-igw"  # Internet Gateway name
  }
}

# Creating a public route table
resource "aws_route_table" "rt_pub_project1" {
  vpc_id = aws_vpc.vpcProject1.id  # VPC ID
  tags = {
    Name = "${var.vpc_name}-rt-pub"  # Public route table name
  }
}

# Creating a route table association for public subnets
resource "aws_route_table_association" "Pub2rt_association" {
  count = length(var.pub_subnet_cidr_blocks)  # Create associations for public subnets based on the count of CIDR blocks
  subnet_id = aws_subnet.Project1_Pub_subnets[count.index].id  # Public subnet ID
  route_table_id = aws_route_table.rt_pub_project1.id  # Public route table ID
}

# Creating a route for the public route table
resource "aws_route" "rt_pub_project1_default" {
  route_table_id = aws_route_table.rt_pub_project1.id  # Public route table ID
  destination_cidr_block = "0.0.0.0/0"  # Destination CIDR block
  gateway_id = aws_internet_gateway.igw_project1.id  # Internet Gateway ID
}

# Creating a NAT gateway Elastic IP
resource "aws_eip" "eip_project1" {
  count = length(var.pri_subnet_cidr_blocks)
  tags = {
    Name = "${var.vpc_name}-eip"  # Elastic IP name
  }
}

# Creating a NAT gateway
resource "aws_nat_gateway" "nat_gw_project1" {
  count = length(var.pri_subnet_cidr_blocks)  # Create NAT gateways based on the count of public subnets
  allocation_id = aws_eip.eip_project1[count.index].id  # Elastic IP allocation ID
  subnet_id = aws_subnet.Project1_Pub_subnets[count.index].id  # Public subnet ID
  tags = {
    Name = "${var.vpc_name}-nat-gw-${count.index + 1}"  # NAT Gateway name
  }
}
# Creating a private route tables
resource "aws_route_table" "rt_pri_project1" {
  count = length(var.pri_subnet_cidr_blocks)
  vpc_id = aws_vpc.vpcProject1.id  # VPC ID
  tags = {
    Name = "${var.vpc_name}-rt-pri-${count.index + 1}"  # Private route table name
  }
}

# Creating a route table association for private subnets to the private route table
resource "aws_route_table_association" "Pri2rt_association" {
  count = length(var.pri_subnet_cidr_blocks)  # Create associations for private subnets based on the count of CIDR blocks
  subnet_id = aws_subnet.Project1_Pri_subnets[count.index].id  # Private subnet ID
  route_table_id = aws_route_table.rt_pri_project1[count.index].id  # Private route table ID
}

# Creating a route for the public route table
resource "aws_route" "rt_pri_project1_default" {
  count = length(var.pri_subnet_cidr_blocks)
  route_table_id = aws_route_table.rt_pri_project1[count.index].id  # Public route table ID
  destination_cidr_block = "0.0.0.0/0"  # Destination CIDR block
  gateway_id = aws_nat_gateway.nat_gw_project1[count.index].id  # Internet Gateway ID
}