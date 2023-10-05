variable "resource_prefix" {
  type        = string
  description = "Prefix should be buName-customerNamer-envName"
}

variable "tags" {
  description = "Mandatory normalized tags to tag the resources accordingly."
  type        = map(string)
}

variable "secret_name" {
  type = string
}

variable "kms_key_id" {
  type = string
}

locals {
  secret_key_value = {
    resource_prefix = var.resource_prefix
  }
}