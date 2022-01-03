variable "ingress_rules" {
    type = list(object({
    from_port     = number
    to_port       = number
    protocol      = string
    cidr_blocks   = list(string)
  }))
  default = [
    {
      from_port      = 80
      to_port        = 80
      protocol       = "TCP"
      cidr_blocks = ["0.0.0.0/0"]
    }
  ]
}


variable "t_AppID" {
  #description = "All environments MUST have an AppId."
  #default     = "SCV1300"
}

variable "t_dcl" {
  #description = "All environments MUST have a t_dcl."
  #default     = "1"
}
variable "t_environment" {
  #description = "All environments MUST have an t_environment."
  #default     = "NONPRD"
}

variable "vpc_id" {
  type    = string
  default = ""
}

variable "vpc_name" {
  type    = string
  default = ""
}

variable "vpc_cidr" {
  type    = string
  default = ""
}
