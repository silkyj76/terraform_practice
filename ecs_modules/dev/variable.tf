#Varibles for dev/variables.tf
variable "region" {
  type        = string
  default     = "us-east-1"
  description = "default region"
}

variable "vpc_name"{
  type    = string
  default = "Default-VPC"
}

variable "instance_tenancy"{
  type        = string
  default     = "default"
  description = ""
}

variable "vpc_cidr" {
  type        = string
  default     = "10.10.0.0/22"
}
