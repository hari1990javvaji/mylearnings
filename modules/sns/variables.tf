variable "resource_prefix" {
  type        = string
  description = "Prefix should be buName-customerNamer-envName"
}

variable "tags" {
  description = "Mandatory normalized tags to tag the resources accordingly."
  type        = map(string)
}

variable "encrypt_key_sns" {
  type    = string
  default = "alias/aws/sns"
}

variable "sns_topics" {
  type = set(string)
}