variable "resource_prefix" {
  type        = string
  description = "Resource prefix"
}

variable "tags" {
  description = "Mandatory normalized tags to tag the resources accordingly."
  type        = map(string)
}

variable "encrypt_algorithm_athena" {
  type    = string
  default = "SSE_KMS"
}

variable "kms_key_arn" {
  type = string
}

variable "bucket_query_result" {
  type = object({
    bucket = string
    arn    = string
  })
}

variable "athena_workgroups" {
  description = "athena workgroups"
  default = {

  }
}