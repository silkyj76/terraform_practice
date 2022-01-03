provider "aws" {
  profile = "default"
  region  = var.region
}

terraform {
  required_version = ">= 0.14, < 2.0.0"
  required_providers {
    aws = {
      source = "registry.terraform.io/hashicorp/aws"
    }
  }
}

module "vpc" {
  source             = "../modules/vpc"
  vpc_cidr           = var.vpc_cidr
  vpc_public_subnet  = var.vpc_public_subnet
  vpc_private_subnet = var.vpc_private_subnet
}

module "security_groups" {
  source        = "../modules/security_group"
  vpc_id        = module.vpc.vpc_id
  vpc_cidr      = var.vpc_cidr
  vpc_name      = var.vpc_name
  t_AppID       = var.t_AppID
  t_dcl         = var.t_dcl
  t_environment = var.t_environment
}

module "alb" {
  source          = "../modules/alb"
  vpc_id          = module.vpc.vpc_id
  #subnets         = [module.vpc.public_subnet_1.id, module.vpc.public_subnet_2.id]
  security_groups = module.security_groups.security_group_id
  azs             = var.azs
  t_AppID         = var.t_AppID
  t_dcl           = var.t_dcl
  t_environment   = var.t_environment
}

module "ec2" {
  source               = "../modules/ec2"
  aws_region           = var.region
  ami_id               = var.ami_id
  instance_type        = var.instance_type
  availability_zones   = var.availability_zones
  key_pair             = var.key_pair
  security_groups      = module.security_groups.security_group_id
  t_AppID              = var.t_AppID
  t_dcl                = var.t_dcl
  t_environment        = var.t_environment
  subnet_id            = var.public_subnet_list[0]
  vpc_security_grp_ids = module.security_groups.security_group_id
  
  
  
}
