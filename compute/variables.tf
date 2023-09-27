# -- compute/variables.tf -- #

variable "subnet_id" {}

variable "vpc_a_subnet_id" {
  type = list(string)
  default = ["10.10.0.0/24"]
}

variable "ec2_name" {}

# Security Groups
variable "sg_ports" {
  type    = list(number)
  default = [0]
}


variable "vpc_id" {
  
}



