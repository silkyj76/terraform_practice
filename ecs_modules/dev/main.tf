/*In order to successfully complete this lab, we must first have a good understanding of the Terraform state and its 
purpose.In my opinion the state file is most important file. The state file contains everything in your configuration, 
including any secrets you might have defined in them. It is the source of truth for the infrastructure being managed.
Although there are some scenarios where the Terraform may be able to function without a state file, it’s not recommended 
at all.The state is used by Terraform to map real world resources to your configuration, In a nutshell Terraform looks at 
what was already provisioned and track the changes in the state file. It is best practice to store the State file remotely, 
it helps tremendously when working in a team setting. The ideal location for the state file is an S3 bucket when working 
with AWS.*/

//This code will allow Terraform to store the state file in a S3 bucket called “terraformbucketsokito”
terraform{
    backend "s3"{
        bucket  = "dylan-testlab-ou812-private" 
        key     = "terraform.tfstate"
        region  = "us-east-1"
    }
}
//In order to keep my login information safe, I will enter AWS Configure to upload my AWS keys without exposing them.

/*Virtual Private Cloud
First service we will establish is the Virtual Private Cloud.

vpc.tf*/
provider "aws" {
    region = "us-east-1"
}/*We are going to use AWS as a provider for this lab. The resource that we are creating here is a Virtual Private Cloud.
The Virtual private cloud is the networking layer of the EC2, it allows you to build your own virtual network within 
AWS. cidr_block here specifies that IPv4 address range of the VPC.*/

module "vpc" {
  source             = "../modules/vpc"
  vpc_cidr           = var.vpc_cidr
  azs                = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d"]
  vpc_name           = var.vpc_name
}

module "security_group" {
  source        = "../modules/security_group"
  vpc_id        = module.vpc.vpc_id
}


/*Autoscaling group
An Auto Scaling group is a collection of EC2 instances managed by the Auto Scaling Service. Before we launch our 
container instances and register them we have to create an IAM role for those instances.*/

module "iam"{
    source = "../modules/iam"
}

module "autoscaling" {
    source = "../modules/autoscale"
  
}

module "rds" {
    source = "../modules/rds"
  
}

module "ecr" {
    source = "../modules/ecr"
  
}

module "ecs" {
    source = "../modules/ecs"
  
}

module "task_definition" {
    source = "../modules/task_definition"
}





