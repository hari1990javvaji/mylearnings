variable "intra_subnet_ids" {
  type        = list(string)
  description = "two exsiting intra subent ids without internet access"
  default     = []
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "two exsiting private subent ids with egress internet access through NAT"
  default     = []
}

variable "vpc_sg_id" {
  type        = string
  description = "security group id attached to the VPC endpoints (used by intra subntes)"
  default     = ""
}

variable "vpc_id" {
  type        = string
  description = "exsiting vpc id to be used"
  default     = ""
}

variable "administrator_users" {
  type        = list(string)
  description = "List of existing users/roles who require an explitcit lake formation administrative priviledges. Note: account administrator does not automatically get LF administrative priviledges."
}