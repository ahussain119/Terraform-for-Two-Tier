# This file is the entry point for the terraform script. It calls the modules and passes the required variables to them.
module "networking" {
    source = "./networking"
    vpc_cidr_block = var.vpc_cidr_block
    vpc_name = var.vpc_name
    pub_subnet_cidr_blocks = var.pub_subnet_cidr_blocks
    pri_subnet_cidr_blocks = var.pri_subnet_cidr_blocks
    availability_zones = var.availability_zones 
}

module "security-groups" {
    source = "./security-groups"
    vpc_id = module.networking.vpc_id
}

module "auto_scaling" {
    source = "./auto_scaling"
    ec2_sg_id = module.security-groups.ec2_sg_id
    subnet_id = module.networking.private_subnet_ids
    ec2_type = var.ec2_type
    ami = var.ami
    target_group_arn = module.loadbalancer.tg_arn
    user_data = base64encode(file("script/script.sh"))
}

module "loadbalancer" {
    source = "./loadbalancer"
    lb_sg_id = module.security-groups.LB_sg_id
    public_subnet_ids = module.networking.public_subnet_ids
    vpc_id = module.networking.vpc_id
}

module "jumper" {
    source = "./jumper"
    ami = var.ami
    jumper_sg_id = module.security-groups.jumper_sg_id
    subnet_id = module.networking.public_subnet_jumper
}