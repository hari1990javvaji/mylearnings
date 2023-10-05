variable "resource_prefix" {
  type        = string
  description = "Prefix should be buName-customerNamer-envName"
}

variable "tags" {
  description = "Mandatory normalized tags to tag the resources accordingly."
  type        = map(string)
}

variable "bucket" {
  type = map(string)
  default = {
    bucket_name       = "test"
    bucket_versioning = "Enabled"
  }
}

variable "bucket_name_label" {
  type    = string
  default = "%s-%s-%s-%s" #oprefix-bucketkey-awsregion-awsaccountid
}

variable "bucket_access_log" {
  type = map(string)
  default = {
    enable_bucket_access_log = false
    bucket_access_log        = ""
  }
}

variable "enable_bucket_access_log" {
  default = false
}

variable "kms_key_arn" {
  type        = string
  description = "KMS key ARN for S3 SSE KMS"
}

variable "bucket_key_enabled" {
  type        = string
  default     = "true"
  description = "Reduce calls to KMS by enabling bucket key"
}

variable "bucket_encryption" {
  type = map(string)
  default = {
    algorithm : "aws:kms"
    kms_id : ""
  }
}
