variable "vpc_id"{
    type    = string
    default = "aws_vpc.vpc_id"
}

variable "cidr_block"{
    type    = list
    default = ["0.0.0.0/0"]
}