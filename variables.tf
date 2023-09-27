# -- variables.tf -- 

variable "aws_region" {
  type    = string
  default = "us-east-1"
}

variable "vpc_cidr_a" {
  default = "10.10.0.0/16"
}


variable "vpc_cidr_b" {
  default = "10.20.0.0/16"
}
