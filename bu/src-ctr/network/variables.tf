variable "private_subnet_ids" {
  type        = list(string)
  description = "two exsiting private subent ids with egress internet access through NAT"
  default     = []
}

variable "vpc_id" {
  type        = string
  description = "exsiting vpc id to be used"
  default     = ""
}