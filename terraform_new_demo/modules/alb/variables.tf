variable "security_groups" {
  type    = string
  default = ""
}

variable "subnets"{
  type = string
  default = ""
}

variable "vpc_id"{
  type = string
  default = ""
}

variable "security_group_id"{
  type = string
  default = ""
}

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

variable "vpc_cidr"{
  type    = string
  default = "10.0.0.0/16"
}

variable "vpc_public_subnet" {
  type    = string
  default = ""
}

variable "vpc_private_subnet" {
  type    = string
  default = ""
}

variable "alb_name" {
  type = string
  default = "dylan_demo_alb"
}

variable "azs" {
  type    = list(any)
  default = ["us-east-1a", "us-east-1b", "us-east-1c"]
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