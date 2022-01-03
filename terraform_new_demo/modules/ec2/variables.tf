variable "t_AppID" {
  #description = "All environments MUST have an AppId. CMSOPS internal team infrastructure environments (Packer, etc) can use SVC01300. If waiting on an AppID, use UNKNOWN temporarily."
  #default     = "SCV1300"
}

variable "t_dcl" {
  #description = "All environments MUST have an AppId. CMSOPS internal team infrastructure environments (Packer, etc) can use SVC01300. If waiting on an AppID, use UNKNOWN temporarily."
  #default     = "1"
}
variable "t_environment" {
  #description = "All environments MUST have an AppId. CMSOPS internal team infrastructure environments (Packer, etc) can use SVC01300. If waiting on an AppID, use UNKNOWN temporarily."
  #default     = "NONPRD"
}


variable "aws_region" {
  default = "us-east-1"
}

variable "vpc_id"{
  type = string
  default = ""
}

variable "ami_id" {
  type = string

  /*default = "ami-0ab4d1e9cf9a1215a"
  type = map(any)

  default = {
    "us-east-1a" = "ami-0d296d66f22f256c2"
    "us-east-1b" = "ami-0d296d66f22f256c2"
    "us-east-1c" = "ami-0d296d66f22f256c2"
  }*/
}
variable "instance_type" {
  #description = "the instance type used for all ec2instance instances"
  #default     = "t2.micro"
}
variable "key_pair" {
  #description = "generated key-pair for all ec2instance instances"
  #default     = "projectALkeypairs"
}

variable "availability_zones" {
  /*type    = list(any)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]*/
}

variable "availability_zone_2" {
  type    = string
  default = ""
}

variable "public_subnet_list" {
  type    = string
  default = ""
}

variable "security_groups" {
  type    = string
  default = ""
}

variable "subnet_id"{
  type    = string
  default = ""
}

variable "vpc_security_grp_ids" {
  type    = string
  default = ""
}
