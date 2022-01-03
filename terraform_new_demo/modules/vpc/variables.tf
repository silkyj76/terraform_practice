variable "vpc_cidr"{
  type    = string
  default = ""
}

variable "vpc_public_subnet" {
  type    = string
  default = ""
}

variable "vpc_private_subnet" {
  type    = string
  default = ""
}

variable "availability_zone" {
    type    = string
    default = "us-east-1a"
}

variable "vpc_id" {
    type    = string
    default = "aws_vpc.dylan_demo_vpc.id"
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

variable "security_groups" {
  type    = string
  default = ""
}