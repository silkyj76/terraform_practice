variable "region" {
  type        = string
  description = "Region where we will create our resources"
  default     = "us-east-1"
}

#Availability zones
variable "azs" {
  type        = list(string)
  description = "Availability zones"
}

variable "ami" {
  type        = list(string)
  description = "Availability zones"
}