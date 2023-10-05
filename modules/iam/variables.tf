variable "resource_prefix" {
  type        = string
  description = "Prefix should be buName-customerNamer-envName"
}

variable "tags" {
  description = "Mandatory normalized tags to tag the resources accordingly."
  type        = map(string)
}

variable "lakeformation_role_name" {
  type = string
}

variable "lf_role_policy" {
  type = string
}

variable "gluecrawler_role_name" {
  type = string
}

variable "buckets_nonsensitive_arns" {
  type = set(string)
}

variable "lakeformation_service_endpoint" {
  type        = string
  default     = "lakeformation.amazonaws.com"
  description = "This is used for iam role assignment, changes for china"
}

variable "glue_service_endpoint" {
  type        = string
  default     = "glue.amazonaws.com"
  description = "This is used for iam role assignment, changes for china"
}