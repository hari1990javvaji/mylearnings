variable "resource_prefix" {
  type        = string
  description = "Prefix should be buName-customerNamer-envName"
}

variable "tags" {
  description = "Mandatory normalized tags to tag the resources accordingly."
  type        = map(string)
}

variable "administrator_role" {
  type = any
}

variable "administrator_users" {
  type    = list(string)
  default = [""]
}


variable "deployment_role" {
  type = any
}