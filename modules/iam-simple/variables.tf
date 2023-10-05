variable "resource_prefix" {
  type        = string
  description = "Prefix should be buName-customerNamer-envName"
}

variable "tags" {
  description = "Mandatory normalized tags to tag the resources accordingly."
  type        = map(string)
}

variable "role_name" {
  type = string
}

variable "assume_policy" {
  description = "A valid policy JSON document. For more information about building AWS IAM policy documents with Terraform, see the AWS IAM Policy Document Guide."
  type        = string
}

variable "inline_policy" {
  description = "A valid policy JSON document. For more information about building AWS IAM policy documents with Terraform, see the AWS IAM Policy Document Guide."
  type        = string
}