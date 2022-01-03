# Input Variables
variable "region" {
  type    = string
  default = "us-east-1"
}

variable "aws_account_id" {
  type    = string
  default = "992567842996"
}

variable "vpc_id" {
  type    = string
  default = "aws_vpc.dylan_demo_vpc.id"
}

variable "public_subnet_list" {
  default = ["10.0.1.0/24", "10.0.2.0/24" /*"10.43.60.0/24", "10.43.70.0/24", "10.43.80.0/24"*/]
}

variable "security_group_id" {
  type = string
  default = "aws_security_group.dylan_demo_sg.id"
}

variable "vpc_cidr" {
  type    = string
  default = "10.0.0.0/16"
}

variable "vpc_public_subnet" {
  type    = string
  default = "10.0.1.0/24"
}

variable "vpc_private_subnet" {
  type    = string
  default = "10.0.2.0/24"
}

variable "azs" {
  #type    = list(any)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "availability_zones" {
  type    = list(string)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "instance_count" {
  default = 3
}

variable "ami_id" {
  type    = string
  default = "ami-0ab4d1e9cf9a1215a"
}

variable "image_id" {
  type    = string
  default = "ami-0ab4d1e9cf9a1215a"
}

variable "instance_type" {
  type        = string
  description = "the instance type used for all ec2 instances"
  default     = "t2.micro"
}
variable "key_pair" {
  type        = string
  description = "generated key-pair for all ec2 instances"
  default     = "projectALkeypairs"
}

variable "availability_zone_1" {
  type    = string
  default = "us-east-1a"
}

variable "availability_zone_2" {
  type    = string
  default = "us-east-1b"
}

variable "availability_zone_3" {
  type    = string
  default = "us-east-1c"
}

variable "max_size" {
  default = 3
}

variable "min_size" {
  default = 3
}

variable "desired_capacity" {
  default = 3
}

variable "auto_scaling_name" {
  default = "intern_auto_scaling_AL"
}

variable "launch_template_name" {
  default = "intern_launch_template_AL"
}

variable "health_check_type" {
  default = "ELB"
}

variable "health_check_grace_period" {
  type    = number
  default = 300
}

variable "ecs_cluster_name" {
  default = "intern_ecs_clusterAL"
}

variable "security_groups" {
  type    = string
  default = ""
}

variable "ecs_task_definition_name" {
  default = "intern_task_defAL"
}

variable "connection_ports" {
  default = 80
}

variable "image_name" {
  default = "terraform:0.4"
}

variable "container_name" {
  default = "web4ecslatest"
}

variable "ecs_service_name" {
  default = "intern_ecs_serviceAL"
}

variable "subnet_id" {
  type    = string
  default = ""
}

/*data "aws_subnet" "selected" {
  id = var.subnet_id
}

resource "aws_security_group" "subnet" {
  vpc_id = data.aws_subnet.selected.vpc_id

  ingress {
    cidr_blocks = [data.aws_subnet.selected.cidr_block]
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  }
}*/

#VARIABLES FOR TAGS

variable "vpc_name" {
  description = "Name of the VPC. Will be the prefix for all named resources. If you already have this variable, replace it with this one"
  default     = "intern_demo_vpc_AL"
}

variable "project" {
  description = "The project tag. If you already have this variable, replace it with this one"
  default     = "intern_AL_infra_proj"
}


# AllowedValues: [Development, Prod, Staging, User Acceptance Testing, Quality Assurance, Test, Integration, Disaster Recovery]
variable "t_environment" {
  description = "Type of environment"
  default     = "NONPRD"
}

variable "t_AppID" {
  description = "All environments MUST have an AppId. CMSOPS internal team infrastructure environments (Packer, etc) can use SVC01300. If waiting on an AppID, use UNKNOWN temporarily."
  default     = "SCV1300"
}


variable "t_dcl" {
  description = "The DCL level of the environment. See the spreadsheet for details. Note that Non-Prod environments that do not have Prod data can be considered one level lower than their Prod counterpart."
  default     = "1"
}

